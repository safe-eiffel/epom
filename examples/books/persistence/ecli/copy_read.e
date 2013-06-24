note

	
		description: "Read copy"
	
	status: "Cursor/Query automatically generated for 'COPY_READ'. DO NOT EDIT!"
	generated: "2013/06/20 17:52:20.171"
	generator_version: "v1.7.2"
	source_filename: "copy.xml"

class COPY_READ

inherit

	ECLI_CURSOR
		redefine
			initialize
		end


create

	make

feature  -- -- Access

	parameters_object: detachable COPY_ID

	item: COPY_ROW

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
select isbn, serial_number, LOC_STORE, LOC_SHELF, LOC_ROW, BORROWER 
from COPY 
where isbn=?isbn and serial_number=?serial_number
]"

feature {NONE} -- Implementation

	create_buffers
			-- Creation of buffers
		local
			buffers: like results
		do
			create buffers.make (1,0)
			buffers.force (item.isbn, 1)
			buffers.force (item.serial_number, 2)
			buffers.force (item.loc_store, 3)
			buffers.force (item.loc_shelf, 4)
			buffers.force (item.loc_row, 5)
			buffers.force (item.borrower, 6)
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
