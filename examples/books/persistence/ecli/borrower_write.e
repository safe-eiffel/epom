note

	
		description: "Write Borrower"
	
	status: "Cursor/Query automatically generated for 'BORROWER_WRITE'. DO NOT EDIT!"
	generated: "2012/10/16 08:36:39.437"
	generator_version: "v1.7"
	source_filename: "C:\User\Eiffel\Dev\github\epom\examples\books\persistence\ecli\borrower.xml"

class BORROWER_WRITE

inherit

	ECLI_QUERY


create

	make

feature  -- -- Access

	parameters_object: detachable BORROWER_MODIFY_PARAMETERS

feature  -- -- Element change

	set_parameters_object (a_parameters_object: BORROWER_MODIFY_PARAMETERS)
			-- set `parameters_object' to `a_parameters_object'
		require
			a_parameters_object_not_void: a_parameters_object /= Void
		do
			parameters_object := a_parameters_object
			put_parameter (parameters_object.id,"id")
			put_parameter (parameters_object.address,"address")
			put_parameter (parameters_object.name,"name")
			bind_parameters
		ensure
			bound_parameters: bound_parameters
		end

feature  -- Constants

	definition: STRING = "[
insert into borrower values (?id, ?name, ?address)
]"

end
