note

	description:

		"Access modules to persistent state of BOOK instances  (EiffelStore)."

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class BOOK_ADAPTER_EIFFELSTORE

inherit

	BOOK_ADAPTER
	
	EIFFELSTORE_SIMPLE_ADAPTER[BOOK]
		redefine
			is_pid_valid, last_pid
		end
		
create
	make
	
feature -- Initialization

feature -- Access
	
	last_pid : BOOK_PID
	
feature -- Measurement

feature -- Status report

	can_read : BOOLEAN = True
	can_delete : BOOLEAN = True
	can_write : BOOLEAN = True
	can_update : BOOLEAN = True
	can_refresh : BOOLEAN = True

feature -- Basic operations

	create_pid_from_object (an_object: BOOK)
		do
			status.reset
			create last_pid.make_from_isbn (an_object.isbn)			
		end
		
	read_by_isbn (an_isbn : STRING)
		do
			create last_pid.make_from_isbn (an_isbn)
			read (last_pid)
		end

	read_by_title (a_title : STRING)
		do
			create selection.make
			selection.set_map_name (a_title, "title")
			read_object_collection (sql_read_by_title)
		end
		
	read_by_author (author_name : STRING)
		do
			create selection.make
			selection.set_map_name (author_name, "author")
			read_pid_collection ("select isbn from book where author = :author_name")
		end

feature {NONE} -- Inapplicable

	row : BOOK_ROW

	pid_row : BOOK_ROW do Result := row end
	
	create_row do  create row end	
	
	create_pid_row do create_row end
	
feature {NONE} -- Implementation

	sql_read_by_title : STRING = "select isbn, title, author from book where title like :title"
	
	sql_exists: STRING = "select count(*) as exists_count from BOOK where isbn = :isbn"
	
	init_parameters_for_exists (pid : like last_pid)
		do
				selection.set_map_name (pid.isbn, "isbn")
		end

	init_parameters_for_read (pid : like last_pid)
		do
				selection.set_map_name (pid.isbn, "isbn")
		end

	init_parameters_for_refresh (t : like last_pid)
			-- Initialize refresh query parameters with pid information.
		do
			init_parameters_for_read (t)		
		end

	init_parameters_for_delete (p : like last_pid)
		do
				change.set_map_name (p.isbn, "isbn")
		end

	init_parameters_for_write (o : like last_object; p : like last_pid)
		do
				change.set_map_name (p.isbn, "isbn")
				change.set_map_name (o.title, "title")
				change.set_map_name (o.author, "author")
		end

	init_parameters_for_update (o : like last_object; p : like last_pid)
		do
				change.set_map_name (p.isbn, "isbn")
				change.set_map_name (o.title, "title")			
				change.set_map_name (o.author, "author")
		end
		
	sql_read: STRING = "select isbn, title, author from BOOK where isbn = :isbn"
	
	sql_refresh: STRING do Result := sql_read end
	
	sql_update: STRING = "update book set title = :title , author = :author where isbn = :isbn"

	sql_write: STRING = "insert into book values (:isbn, :title, :author)"

	sql_delete : STRING = "delete from book where isbn = :isbn"

	create_object_from_row
		local
			isbn, title, author : STRING
		do
			isbn := clone (row.isbn)
			title := clone (row.title)
			author := clone (row.author)
			create last_object.make (isbn, row.title, row.author)
		end
		
	fill_object_from_row
		do			
		end

	create_pid_from_pid_row
		do
			create last_pid.make_from_isbn (clone (pid_row.isbn))
		end
		
invariant

	change_not_void:  change /= Void
	selection_not_void:  selection /= Void
	
end
