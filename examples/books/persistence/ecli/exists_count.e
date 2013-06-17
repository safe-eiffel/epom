note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/10/16 08:36:50.375"
	generator_version: "v1.7"
	source_filename: "C:\User\Eiffel\Dev\github\epom\examples\books\persistence\ecli\book.xml"

class EXISTS_COUNT

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create exists_count.make
		ensure
			exists_count_is_null: exists_count.is_null
		end

feature  -- Access

	exists_count: ECLI_INTEGER

end
