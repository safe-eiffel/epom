note

	description:

		"Adapters for BORROWER objects  (EiffelStore)."

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class BORROWER_ADAPTER_EIFFELSTORE

inherit

	BORROWER_ADAPTER
	
	EIFFELSTORE_SIMPLE_ADAPTER[BORROWER]
		redefine
			is_pid_valid, last_pid
		end
		
create
	make
	
feature -- Access

	last_pid : BORROWER_PID
	
feature -- Status report
	
	can_read : BOOLEAN = True
	can_delete : BOOLEAN = True
	can_write : BOOLEAN = True
	can_update : BOOLEAN = True
	can_refresh : BOOLEAN = True
		
feature -- Basic operations

	create_pid_from_object (an_object: BORROWER)
		do
			create_pid_from_id (an_object.id)
		end

	select_by_name (name : STRING)
			-- 
		do
			selection.clear_all
			selection.set_map_name (name, "name")
			read_object_collection ("select name from borrower where name like :name")
		end

		
	read_by_name_pattern (name_pattern : STRING)
			-- Read by name like `name_pattern'.
		do
		end

	read_by_id (id : INTEGER)
			-- Read by `id'.
		do
			create_pid_from_id (id)
			read (last_pid)
		end

feature {PO_ADAPTER} -- Factory

	create_pid_from_id (id : INTEGER)
			-- 
		do
			create last_pid.make (id)
		end
		
feature -- Inapplicable

	row : BORROWER_ROW

	pid_row : BORROWER_ROW do Result := row end
	
	create_row 
		do 
			create row
		end
	
	create_pid_row 
		do
			create_row
		end
		
feature {NONE} -- Implementation
	
	sql_exists: STRING = "select count (*) as exists_count from borrower where id = :id"
	
	init_parameters_for_exists (pid : like last_pid)
			-- 
		do
			selection.clear_all
			selection.set_map_name (pid.id, "id")			
		end

	sql_read: STRING = "select id, name, address from borrower where id=:id"
	
	init_parameters_for_read (pid : like last_pid)
			-- 
		do
			init_parameters_for_exists (pid)
		end

	sql_refresh: STRING do Result := sql_read end
	

	init_parameters_for_refresh (t : like last_pid)
			-- Initialize refresh query parameters with pid information.
		do
			init_parameters_for_read (t)
		end

	sql_delete : STRING = "delete from borrower where id = :id"

	init_parameters_for_delete (t : like last_pid)
		do
			change.clear_all
			change.set_map_name (t.id, "id")
		end

	sql_write: STRING = "insert into borrower values (:id, :address, :name)"

	init_parameters_for_write (o : like last_object; p : like last_pid)
		do
			change.clear_all
			change.set_map_name (p.id, "id")
			change.set_map_name (o.address, "address")
			change.set_map_name (o.name, "name")
		end

	sql_update: STRING = "update borrower set address =:address, name = :name where id = :id"
	
	init_parameters_for_update (o : like last_object; p : like last_pid)
		do
			change.clear_all
			change.set_map_name (p.id, "id")
			change.set_map_name (o.address, "address")
			change.set_map_name (o.name, "name")
		end
		
	create_object_from_row
		do 
			create last_object.make (row.id, clone (row.name), clone(row.address))
		end
		
	fill_object_from_row
			-- 
		do

		end

	create_pid_from_pid_row
		do
			create_pid_from_id (row.id)
		end

end
