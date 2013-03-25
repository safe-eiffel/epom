note
	description: "Caches of Persistent objects, implemented with a hash table"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	PO_HASHED_CACHE [G -> PO_PERSISTENT]

inherit
	PO_CACHE [G]

create
	make

feature -- Initialization

	make (new_capacity : INTEGER)
			-- Make with capacity `new_capacity'
		do
			create table.make (new_capacity)
			table.set_equality_tester (create {KL_EQUALITY_TESTER[G]})
			create pid_list.make
		ensure
			capacity_set: capacity = new_capacity
		end

feature -- Access

	item (pid : PO_PID) : detachable G
		do
			Result := table.item (pid.as_string)
		end

	new_cursor : DS_LIST_CURSOR [PO_PID]
		local
			r : detachable like new_cursor
		do
			r := pid_list.new_cursor
			check r /= Void end
			Result := r
		end

	found_item : detachable G
		do
			Result := table.found_item
		end

feature -- Measurement

	count : INTEGER
			-- Count of items.
		do
			Result := table.count
		end

	capacity : INTEGER
			-- Capacity of container.
		do
			Result := table.capacity
		end

feature -- Status report

	has (pid : PO_PID) : BOOLEAN
		do
			Result := table.has (pid.as_string)
		end

	found : BOOLEAN

feature -- Element change

	put (object : G)
		do
			table.force (object, object.pid.as_string)
			pid_list.put_last (object.attached_pid)
		end

	put_void (pid : PO_PID)
		do
			table.force (default_value, pid.as_string)
			pid_list.put_last (pid)
		end

feature -- Removal

	remove (pid : PO_PID)
		local
			cursor : detachable DS_LIST_CURSOR[PO_PID]
		do
			table.remove (pid.as_string)
			cursor := pid_list.new_cursor
			check cursor /= Void end
			cursor.start
			cursor.search_forth (pid)
			if not cursor.off then
				cursor.remove
			end
		ensure then
			removed_from_list: not pid_list.has (pid)
		end

	wipe_out
		do
			table.wipe_out
			pid_list.wipe_out
		end

feature -- Basic operations

	search (a_pid : PO_PID)
		do
			table.search (a_pid.as_string)
			found := table.found
		end

feature {NONE} -- Implementation

	pid_list : DS_LINKED_LIST[PO_PID]

	table : DS_HASH_TABLE [detachable G, STRING]

	default_value : detachable G do  end

invariant

	pid_list_not_void: pid_list /= Void
	table_not_void: table /= Void

end -- class PO_HASHED_CACHE
