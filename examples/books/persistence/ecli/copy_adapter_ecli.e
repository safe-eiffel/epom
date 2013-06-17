note

	description:

		"Adapters that interface COPY object with a corresponding datastore"

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class COPY_ADAPTER_ECLI

inherit

	COPY_ADAPTER
		redefine
			on_adapter_connected, on_adapter_disconnect
		end

	ECLI_ADAPTER_READ_SKELETON[COPY]
		redefine
			last_pid
		end

	ECLI_ADAPTER_WRITE_SKELETON[COPY]
		redefine
			last_pid
		end

	ECLI_ADAPTER_UPDATE_SKELETON[COPY]
		redefine
			last_pid
		end

	ECLI_ADAPTER_DELETE_SKELETON[COPY]
		redefine
			last_pid
		end

	ECLI_ADAPTER_REFRESH_SKELETON[COPY]
		redefine
			last_pid
		end

	ECLI_ADAPTER_SINK_SKELETON[COPY]
		undefine
			on_adapter_connected, on_adapter_disconnect,
			can_delete, can_read, can_write, can_update, can_refresh,
			delete, read, write, update, refresh
		redefine
			last_pid
		end

	COPY_ADAPTER_ACCESS_ROUTINES
		rename
			copy_borrowed as read_borrowed
		end

create

	make

feature {NONE} -- Access

	last_pid : detachable COPY_PID

feature -- Basic operations

	read_borrowed
		require else
			True
		local
			cursor : COPY_BORROWED
		do
			create cursor.make (datastore.session)
			create last_cursor.make
			do_copy_borrowed (cursor)
			cursor.close
			last_object := Void
		end

	read_from_isbn_and_number (an_isbn : STRING; a_number : INTEGER)
		do
			create last_pid.make (an_isbn, a_number)
			read (last_pid)
		end

	read_from_isbn (isbn : STRING)
			-- Read copies identified by `isbn'.
		do

		end

feature {NONE} -- Framework - Factory

	create_pid_from_object (an_object : attached like object_anchor)
			--
		do
			create last_pid.make (an_object.book.isbn, an_object.number)
		end

	extend_cursor_from_copy_id (id : COPY_ID)
		do
			create last_pid.make (id.isbn.as_string, id.serial_number.as_integer)
			last_cursor.add_last_pid (Current)
		end

feature {PO_DATASTORE} -- Framework - Basic operations

	on_adapter_connected
		do
			create read_cursor.make (datastore.session)
			create exists_cursor.make (datastore.session)
			create write_query.make (datastore.session)
			create update_query.make (datastore.session)
			create delete_query.make (datastore.session)
		end

	on_adapter_disconnect
		do
			read_cursor.close
			exists_cursor.close
			write_query.close
			update_query.close
			delete_query.close
		end

feature {NONE} -- Framework - Implementation

	read_cursor : detachable COPY_READ

	exists_cursor : detachable COPY_EXIST

	delete_query : detachable COPY_DELETE

	write_query : detachable COPY_WRITE

	refresh_cursor : detachable like read_cursor
		do
			Result := read_cursor
		end


	update_query : detachable COPY_UPDATE

	copy_id_from_pid (a_pid : like last_pid) : COPY_ID
			--
		do
			create Result.make
			Result.isbn.set_item (a_pid.isbn)
			Result.serial_number.set_item (a_pid.serial)
		end

	exists_value : INTEGER do Result := exists_cursor.item.exists_count.as_integer end

	exists_test (a_cursor : attached like exists_cursor) : BOOLEAN
		do
			a_cursor.start
			if a_cursor.is_ok then
				Result := a_cursor.item.exists_count.as_integer > 0
				a_cursor.go_after
			end
		end

	init_parameters_for_read (a_pid: like last_pid)
		local
			parameters : COPY_ID
		do
			parameters := copy_id_from_pid (a_pid)
			read_cursor.set_parameters_object (parameters)
		end

	init_parameters_for_update (object: attached like last_object; a_pid: attached like last_pid)
		local
			parameters : COPY_UPDATE_PARAMETERS
		do
			create parameters.make
			parameters.isbn.set_item (object.book.isbn)
			parameters.serial_number.set_item (object.number)
			if object.borrower /= Void then
				parameters.borrower.set_item (object.borrower.id)
			end
			parameters.loc_row.set_item (object.row)
			parameters.loc_shelf.set_item (object.shelf)
			parameters.loc_store.set_item (object.store)
			update_query.set_parameters_object (parameters)
		end

	init_parameters_for_write (object: like last_object; a_pid: like last_pid)
		local
			parameters : COPY_WRITE_PARAMETERS
		do
			create parameters.make
			parameters.isbn.set_item (object.book.isbn)
			parameters.serial_number.set_item (object.number)
			if object.borrower /= Void then
				parameters.borrower.set_item (object.borrower.id)
			end
			parameters.loc_row.set_item (object.row)
			parameters.loc_shelf.set_item (object.shelf)
			parameters.loc_store.set_item (object.store)
			write_query.set_parameters_object (parameters)
		end

	init_parameters_for_exists (a_pid: like last_pid)
		do
			exists_cursor.set_parameters_object (copy_id_from_pid (a_pid))
		end

	init_parameters_for_delete (a_pid : attached like last_pid)
		do
			delete_query.set_parameters_object (copy_id_from_pid (a_pid))
		end

	create_object_from_read_cursor (a_cursor : like read_cursor; a_pid : like last_pid)
		local
			book_adapter : BOOK_ADAPTER
			book_name : BOOK_PERSISTENT_CLASS_NAME
			book_reference : PO_REFERENCE[BOOK]
		do
			create book_name
			persistence_manager.search_adapter (book_name.persistent_class_name)
			if persistence_manager.found and then attached {BOOK_ADAPTER} persistence_manager.last_adapter as l_adapter then
				book_adapter := l_adapter
				book_adapter.create_pid_for_isbn (a_cursor.item.isbn.as_string)
				create book_reference.set_pid_from_adapter (book_adapter)
				create last_object.make_lazy (book_reference, a_cursor.item.serial_number.as_integer)
			else
				--FIXME -- Error reporting
			end
		end

	fill_from_refresh_cursor (object : attached like last_object)
		do

		end

	init_parameters_for_refresh (a_pid : attached like last_pid)
		do

		end


	fill_object_from_read_cursor  (a_cursor : like read_cursor; object : like last_object)
		local
--			ba : BORROWER_ADAPTER
			bpn : BORROWER_PERSISTENT_CLASS_NAME
			borrower_id : INTEGER
		do
			object.set_location (a_cursor.item.loc_store.as_integer,
				a_cursor.item.loc_shelf.as_integer,
				a_cursor.item.loc_row.as_integer)
			if not a_cursor.item.borrower.is_null then
				create bpn
				persistence_manager.search_adapter (bpn.persistent_class_name)
				if not persistence_manager.found then
					--| FIXME ERROR!
					status.set_framework_error (status.Error_could_not_find_adapter)
				else
					borrower_id := a_cursor.item.borrower.as_integer
					if borrower_id > 0 then
--						ba ?= persistence_manager.last_adapter
						if attached {BORROWER_ADAPTER} persistence_manager.last_adapter as ba then
							ba.create_pid_from_id (a_cursor.item.borrower.as_integer)
							object.borrower_reference.set_pid_from_adapter (ba)
						else
							status.set_framework_error (status.Error_could_not_find_adapter)
						end
					else
						object.borrower_reference.reset
					end
				end
			end
		end

end
