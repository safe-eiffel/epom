note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/06/18 08:20:38.343"
	generator_version: "v1.7.2"
	source_filename: "book.xml"

class BOOK_MODIFY_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create isbn.make (14)
			create title.make (100)
			create author.make (30)
		ensure
			isbn_is_null: isbn.is_null
			title_is_null: title.is_null
			author_is_null: author.is_null
		end

feature  -- Access

	isbn: ECLI_VARCHAR

	title: ECLI_VARCHAR

	author: ECLI_VARCHAR

end
