note

	description:

		"Objects that implement persistence manager."

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class PO_MANAGER_IMPL

inherit

	PO_MANAGER

create

	make

feature {NONE} -- Initialization

	make
			-- Creation.

		do
			create adapters_table.make (10)
			create error_handler.make_null
		end

feature -- Access

	adapters : DS_LIST [PO_ADAPTER[PO_PERSISTENT]]
--		local
--			cursor : DS_HASH_TABLE_CURSOR[PO_ADAPTER[PO_PERSISTENT],STRING]
		do
			create {DS_LINKED_LIST[PO_ADAPTER[PO_PERSISTENT]]}Result.make
			adapters_table.do_all (agent Result.put_last (?))
--			from
--				cursor := adapters_table.new_cursor
--				cursor.start
--			until
--				cursor.off
--			loop
--				Result.put_last (cursor.item)
--				cursor.forth
--			end
		end

	error_handler : PO_ERROR_HANDLER

feature -- Measurement

	count: INTEGER
		do
			Result := adapters_table.count
		end

feature -- Status report


	found: BOOLEAN
		do
			Result := adapters_table.found
		end

	has_adapter (class_name: STRING): BOOLEAN
		do
			last_adapter := Void
			adapters_table.search (class_name)
			if adapters_table.found then
				Result := True
				last_adapter := adapters_table.found_item
			end
		end

feature -- Element change

feature {PO_LAUNCHER} -- Element change

	add_adapter (an_adapter: PO_ADAPTER [PO_PERSISTENT])
		do
			adapters_table.force (an_adapter, an_adapter.persistent_class_name)
		end

	set_error_handler (an_error_handler : PO_ERROR_HANDLER)
		do
			error_handler := an_error_handler
		end

feature -- Basic operations

	search_adapter (class_name: STRING)
		do
			adapters_table.search (class_name)
			if adapters_table.found then
				last_adapter := adapters_table.found_item
			else
				last_adapter := Void
				status.set_framework_error (status.Error_could_not_find_adapter)
				error_handler.report_could_not_find_adapter (class_name, generator, "search_adapter")
			end
		end

feature {NONE} -- Implementation

	adapters_table : DS_HASH_TABLE [PO_ADAPTER[PO_PERSISTENT], STRING]

invariant

	adapters_table_not_void: adapters_table /= Void

end
