note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/06/18 08:20:47.578"
	generator_version: "v1.7.2"
	source_filename: "borrower.xml"

class BORROWER_ID

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create id.make
		ensure
			id_is_null: id.is_null
		end

feature  -- Access

	id: ECLI_INTEGER

end
