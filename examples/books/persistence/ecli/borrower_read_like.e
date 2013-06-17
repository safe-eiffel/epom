note

	
		description: "Search for borrower with name like some pattern"
	
	status: "Cursor/Query automatically generated for 'BORROWER_READ_LIKE'. DO NOT EDIT!"
	generated: "2012/10/16 08:36:39.375"
	generator_version: "v1.7"
	source_filename: "C:\User\Eiffel\Dev\github\epom\examples\books\persistence\ecli\borrower.xml"

class BORROWER_READ_LIKE

inherit

	ECLI_CURSOR


create

	make

feature  -- -- Access

	parameters_object: detachable BORROWER_READ_LIKE_PARAMETERS

	item: BORROWER_ID

feature  -- -- Element change

	set_parameters_object (a_parameters_object: BORROWER_READ_LIKE_PARAMETERS)
			-- set `parameters_object' to `a_parameters_object'
		require
			a_parameters_object_not_void: a_parameters_object /= Void
		do
			parameters_object := a_parameters_object
			put_parameter (parameters_object.name,"name")
			bind_parameters
		ensure
			bound_parameters: bound_parameters
		end

feature  -- Constants

	definition: STRING = "[
select id from borrower where name like ?name
]"

feature {NONE} -- Implementation

	create_buffers
			-- Creation of buffers
		local
			buffers: like results
		do
			create item.make
			create buffers.make (1,0)
			buffers.force (item.id, 1)
			set_results (buffers)
		end

end
