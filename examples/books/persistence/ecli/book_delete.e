note

	
		description: "delete book"
	
	status: "Cursor/Query automatically generated for 'BOOK_DELETE'. DO NOT EDIT!"
	generated: "2012/10/16 08:36:50.328"
	generator_version: "v1.7"
	source_filename: "C:\User\Eiffel\Dev\github\epom\examples\books\persistence\ecli\book.xml"

class BOOK_DELETE

inherit

	ECLI_QUERY


create

	make

feature  -- -- Access

	parameters_object: detachable BOOK_ID

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
delete from book where isbn = ?isbn
]"

end
