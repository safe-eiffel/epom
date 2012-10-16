note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/10/16 08:34:16.781"
	generator_version: "v1.7"
	source_filename: "C:\User\Eiffel\Dev\github\epom\examples\books\persistence\ecli\copy.xml"

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
