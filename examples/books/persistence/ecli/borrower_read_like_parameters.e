note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/06/18 08:20:47.343"
	generator_version: "v1.7.2"
	source_filename: "borrower.xml"

class BORROWER_READ_LIKE_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create name.make (30)
		ensure
			name_is_null: name.is_null
		end

feature  -- Access

	name: ECLI_VARCHAR

end
