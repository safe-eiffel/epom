note

	
		description: "Does a borrower exists?"
	
	status: "Cursor/Query automatically generated for 'BORROWER_EXIST'. DO NOT EDIT!"
	generated: "2013/06/18 08:20:47.375"
	generator_version: "v1.7.2"
	source_filename: "borrower.xml"

class BORROWER_EXIST

inherit

	ECLI_CURSOR
		redefine
			initialize
		end


create

	make

feature  -- -- Access

	parameters_object: detachable BORROWER_ID

	item: EXISTS_COUNT

feature  -- -- Element change

	set_parameters_object (a_parameters_object: BORROWER_ID)
			-- set `parameters_object' to `a_parameters_object'
		require
			a_parameters_object_not_void: a_parameters_object /= Void
		do
			parameters_object := a_parameters_object
			put_parameter (parameters_object.id,"id")
			bind_parameters
		ensure
			bound_parameters: bound_parameters
		end

feature  -- Constants

	definition: STRING = "[
select count (*) as exists_count from borrower where id = ?id
]"

feature {NONE} -- Implementation

	create_buffers
			-- Creation of buffers
		local
			buffers: like results
		do
			create buffers.make (1,0)
			buffers.force (item.exists_count, 1)
			set_results (buffers)
		end

feature {NONE} -- Initialization

	initialize
			-- <Precursor>
		do
			Precursor
			create item.make
		end

end
