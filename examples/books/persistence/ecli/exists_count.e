note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/06/20 17:52:20.796"
	generator_version: "v1.7.2"
	source_filename: "copy.xml"

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
