note

	
		description: "read book by isbn"
	
	status: "Cursor/Query automatically generated for 'BOOK_READ_BY_ISBN'. DO NOT EDIT!"
	generated: "2013/06/18 08:20:38.156"
	generator_version: "v1.7.2"
	source_filename: "book.xml"

class BOOK_READ_BY_ISBN

inherit

	ECLI_CURSOR
		redefine
			initialize
		end


create

	make

feature  -- -- Access

	parameters_object: detachable BOOK_ID

	item: BOOK_ROW

feature  -- -- Element change

	set_parameters_object (a_parameters_object: BOOK_ID)
			-- set `parameters_object' to `a_parameters_object'
		require
			a_parameters_object_not_void: a_parameters_object /= Void
		do
			parameters_object := a_parameters_object
			put_parameter (parameters_object.isbn,"isbn")
			bind_parameters
		ensure
			bound_parameters: bound_parameters
		end

feature  -- Constants

	definition: STRING = "[
select isbn, title, author from BOOK where isbn = ?isbn
]"

feature {NONE} -- Implementation

	create_buffers
			-- Creation of buffers
		local
			buffers: like results
		do
			create buffers.make (1,0)
			buffers.force (item.isbn, 1)
			buffers.force (item.title, 2)
			buffers.force (item.author, 3)
			set_results (buffers)
		end

feature {NONE} -- Initialization

	initialize
			-- <Precursor>
		do
			Precursor
			create item.make
		end

end
