note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/10/16 08:36:39.515"
	generator_version: "v1.7"
	source_filename: "C:\User\Eiffel\Dev\github\epom\examples\books\persistence\ecli\borrower.xml"

class BORROWER_MODIFY_PARAMETERS

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create id.make
			create address.make (50)
			create name.make (30)
		ensure
			id_is_null: id.is_null
			address_is_null: address.is_null
			name_is_null: name.is_null
		end

feature  -- Access

	id: ECLI_INTEGER

	address: ECLI_VARCHAR

	name: ECLI_VARCHAR

end
