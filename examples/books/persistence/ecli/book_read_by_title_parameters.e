note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/06/18 08:20:38.250"
	generator_version: "v1.7.2"
	source_filename: "book.xml"

class BOOK_READ_BY_TITLE_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create title.make (100)
		ensure
			title_is_null: title.is_null
		end

feature  -- Access

	title: ECLI_VARCHAR

end
