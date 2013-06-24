note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/06/18 08:20:47.609"
	generator_version: "v1.7.2"
	source_filename: "borrower.xml"

class BORROWER_ROW

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create id.make
			create name.make (30)
			create address.make (50)
		ensure
			id_is_null: id.is_null
			name_is_null: name.is_null
			address_is_null: address.is_null
		end

feature  -- Access

	id: ECLI_INTEGER

	name: ECLI_VARCHAR

	address: ECLI_VARCHAR

end
