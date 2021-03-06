note
	description: "Caches that hold PO_PERSISTENT object keyed by their pid"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class 	PO_CACHE [G-> PO_PERSISTENT]

feature -- Access

	item (a_pid : PO_PID) : detachable G
			-- Item associated to `a_pid'.
		require
			a_pid_not_void: a_pid /= Void
			has_a_pid: has (a_pid)
		deferred
		ensure
			same_pids: Result /= Void implies Result.pid.is_equal (a_pid)
		end

	new_cursor : DS_LIST_CURSOR[PO_PID]
			-- Cursor on a list of PO_PID that are associated in Current.
		deferred
		ensure
			result_not_void: Result /= Void
		end

	found_item : detachable G
			-- Found item by last search operation.
		deferred
		end

feature -- Measurement

	count : INTEGER
			-- Count of cached objects.
		deferred
		end

feature -- Status report

	has (a_pid : PO_PID) : BOOLEAN
			-- Has `a_pid' been associated ?
		require
			a_pid_not_void: a_pid /= Void
		deferred
		ensure
			definition: Result implies attached item (a_pid) as l_item and then a_pid.is_equal (l_item.attached_pid)
		end

	has_item (object : G) : BOOLEAN
			-- Is `object' cached ?
		require
			object_not_void: object /= Void
		do
			if object.is_persistent then
				search (object.attached_pid)
				if found then
					Result := (object = found_item)
				end
			end
		ensure
			definition: Result implies (object.is_persistent and then has (object.attached_pid) and then item (object.attached_pid) = object)
		end

	found : BOOLEAN
			-- Has last search operation succeeded ?
		deferred
		end

feature -- Element change

	put (object : G)
			-- Put `object' in cache.
		require
			object_not_void: object /= Void
			object_persistent: object.is_persistent
		deferred
		ensure
			definition: has (object.attached_pid) and then item (object.attached_pid) = object
		end

	put_void (pid : PO_PID)
			-- Cache the fact that `pid' is associated with Void.
		require
			pid_not_void: pid /= Void
		deferred
		ensure
			definition: has (pid) and then item (pid) = Void
		end

	remove (pid : PO_PID)
			-- Remove the association [pid, object].
		require
			pid_not_void: pid /= Void
		deferred
		ensure
			definition: not has (pid)
		end

feature -- Basic operations

	wipe_out
			-- Wipe all elements.
		deferred
		ensure
			no_items: count = 0
		end

	search (a_pid : PO_PID)
			-- Search for `a_pid'.
		require
			a_pid_not_void: a_pid /= Void
		deferred
		end

end -- class PO_CACHE
