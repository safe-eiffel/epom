note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/06/18 08:20:38.312"
	generator_version: "v1.7.2"
	source_filename: "book.xml"

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
