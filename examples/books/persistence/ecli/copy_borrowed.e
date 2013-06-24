note

	
		description: "Get the borrowed copies"
	
	status: "Cursor/Query automatically generated for 'COPY_BORROWED'. DO NOT EDIT!"
	generated: "2013/06/20 17:52:20.031"
	generator_version: "v1.7.2"
	source_filename: "copy.xml"

class COPY_BORROWED

inherit

	ECLI_CURSOR
		redefine
			initialize
		end


create

	make

feature  -- -- Access

	item: COPY_ID

feature  -- Constants

	definition: STRING = "[
select isbn, serial_number from copy where borrower is not null and borrower > 0
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
