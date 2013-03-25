note

	description:

		"Adapters for COPY objects (EiffelStore)."

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class COPY_ADAPTER_EIFFELSTORE

inherit

	COPY_ADAPTER
	
	EIFFELSTORE_SIMPLE_ADAPTER[COPY]
		redefine
			is_pid_valid, last_pid
		end
		
create
	make
	
feature -- Access


	last_pid : COPY_PID
	
feature -- Status report

	
	can_read : BOOLEAN = True
	can_delete : BOOLEAN = True
	can_write : BOOLEAN = True
	can_update : BOOLEAN = True
	can_refresh : BOOLEAN = True
	
feature -- Basic operations

	create_pid_from_object (an_object: COPY)
		do
			create_pid_from_id (an_object.isbn, an_object.number)
		end
	
	read_borrowed
			-- Read borrowed copies.
		do
			read_pid_collection ("select isbn, serial_number from copy where borrower is not null and borrower > 0")
		end

	read_from_isbn_and_number (isbn: STRING; number: INTEGER)
		do
			create last_pid.make (isbn, number)
			read (last_pid)
		end

	read_from_isbn (an_isbn : STRING)
		do
			create selection.make
			selection.set_map_name (an_isbn, "isbn")
			read_pid_collection ("select isbn, serial_number from copy where isbn = :isbn")
		end
		
feature -- Inapplicable

	row : COPY_ROW

	pid_row : COPY_ROW do Result := row end
	
	create_row 
		do 
			create row
		end
		
	create_pid_row 
		do
			create_row
		end
		
feature {NONE} -- Implementation
		
	sql_exists: STRING = "select count (*) as exists_count from COPY where isbn=:isbn and serial_number=:serial_number"
	
	init_parameters_for_exists (pid : like last_pid)
			-- 
		do
			selection.clear_all
			selection.set_map_name (pid.isbn, "isbn")
			selection.set_map_name (pid.serial, "serial_number")
		end

	sql_read: STRING = "select isbn, serial_number, LOC_STORE, LOC_SHELF, LOC_ROW, BORROWER from COPY where isbn=:isbn and serial_number=:serial_number"
	
	init_parameters_for_read (pid : like last_pid)
			-- 
		do
			selection.clear_all
			selection.set_map_name (pid.isbn, "isbn")
			selection.set_map_name (pid.serial, "serial_number")
		end

	sql_refresh: STRING do Result := sql_read end
	

	init_parameters_for_refresh (t : like last_pid)
			-- Initialize refresh query parameters with pid information.
		do
			init_parameters_for_read (t)
		end

	sql_delete : STRING = "delete from copy where isbn=:isbn and serial_number=:serial_number"

	init_parameters_for_delete (t : like last_pid)
		do
			change.clear_all
			change.set_map_name (t.isbn, "isbn")
			change.set_map_name (t.serial, "serial_number")
		end

	sql_write: STRING = "insert into copy values (:isbn, :serial_number, :loc_store, :loc_shelf, :loc_row, :borrower )"

	init_parameters_for_write (o : like last_object; p : like last_pid)
		do
			change.clear_all
			change.set_map_name (p.isbn, "isbn")
			change.set_map_name (p.serial, "serial_number")
			change.set_map_name (o.store,"loc_store")
			change.set_map_name (o.shelf,"loc_shelf")
			change.set_map_name (o.row,"loc_row")
			if o.borrower /= Void then
				change.set_map_name (o.borrower.name,"borrower")
			end
		end

	sql_update: STRING = "update copy set loc_store=:loc_store, loc_shelf = :loc_shelf, loc_row=:loc_row, borrower=:borrower where isbn=:isbn and serial_number =:serial_number"
	
	init_parameters_for_update (o : like last_object; p : like last_pid)
		do
			change.clear_all
			change.set_map_name (p.isbn, "isbn")
			change.set_map_name (p.serial, "serial_number")
			change.set_map_name (o.store,"loc_store")
			change.set_map_name (o.shelf,"loc_shelf")
			change.set_map_name (o.row,"loc_row")
			if o.borrower /= Void then
				change.set_map_name (o.borrower.id ,"borrower")
			end
		end
		
	create_object_from_row
		local
			isbn : STRING
			serial_number : INTEGER
		do
			isbn := clone (row.isbn)
			serial_number := row.serial_number
			
			create last_object.make (isbn, serial_number)
		end
		
	fill_object_from_row
			-- 
		local
			borrower_adapter : BORROWER_ADAPTER
		do
			last_object.set_location (row.loc_store, row.loc_shelf, row.loc_row)
			persistence_manager.search_adapter ("BORROWER")
			if persistence_manager.found then
				borrower_adapter ?= persistence_manager.last_adapter
				if row.borrower > 0 then
					borrower_adapter.create_pid_from_id (row.borrower)
					last_object.borrower_reference.set_pid_from_adapter (borrower_adapter)
				end
			end
		end

	create_pid_from_pid_row
		do
			create_pid_from_id (row.isbn, row.serial_number.to_integer)
		end
		
	create_pid_from_id (isbn : STRING; number : INTEGER)
			--  primary key is isbn, serial_number
		do
			create last_pid.make (isbn, number)
		end

end
