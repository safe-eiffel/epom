note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/10/16 08:36:50.359"
	generator_version: "v1.7"
	source_filename: "C:\User\Eiffel\Dev\github\epom\examples\books\persistence\ecli\book.xml"

class BOOK_ID

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create isbn.make (14)
		ensure
			isbn_is_null: isbn.is_null
		end

feature  -- Access

	isbn: ECLI_VARCHAR

end
