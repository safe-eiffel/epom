note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/10/16 08:36:39.390"
	generator_version: "v1.7"
	source_filename: "C:\User\Eiffel\Dev\github\epom\examples\books\persistence\ecli\borrower.xml"

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
