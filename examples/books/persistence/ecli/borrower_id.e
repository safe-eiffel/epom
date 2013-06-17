note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/10/16 08:36:39.515"
	generator_version: "v1.7"
	source_filename: "C:\User\Eiffel\Dev\github\epom\examples\books\persistence\ecli\borrower.xml"

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
