note

	
		description: "Update borrower"
	
	status: "Cursor/Query automatically generated for 'BORROWER_UPDATE'. DO NOT EDIT!"
	generated: "2013/06/18 08:20:47.468"
	generator_version: "v1.7.2"
	source_filename: "borrower.xml"

class BORROWER_UPDATE

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
update borrower set name=?name, address =?address where id=?id
]"

end
