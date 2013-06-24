note

	
		description: "Delete copy"
	
	status: "Cursor/Query automatically generated for 'COPY_DELETE'. DO NOT EDIT!"
	generated: "2013/06/20 17:52:20.265"
	generator_version: "v1.7.2"
	source_filename: "copy.xml"

class COPY_DELETE

inherit

	ECLI_QUERY


create

	make

feature  -- -- Access

	parameters_object: detachable COPY_ID

feature  -- -- Element change

	set_parameters_object (a_parameters_object: COPY_ID)
			-- set `parameters_object' to `a_parameters_object'
		require
			a_parameters_object_not_void: a_parameters_object /= Void
		do
			parameters_object := a_parameters_object
			put_parameter (parameters_object.isbn,"isbn")
			put_parameter (parameters_object.serial_number,"serial_number")
			bind_parameters
		ensure
			bound_parameters: bound_parameters
		end

feature  -- Constants

	definition: STRING = "[
delete from copy where isbn=?isbn and serial_number=?serial_number
]"

end
