note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/06/20 17:52:20.718"
	generator_version: "v1.7.2"
	source_filename: "copy.xml"

class COPY_ID

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create isbn.make (14)
			create serial_number.make
		ensure
			isbn_is_null: isbn.is_null
			serial_number_is_null: serial_number.is_null
		end

feature  -- Access

	isbn: ECLI_VARCHAR

	serial_number: ECLI_INTEGER

end
