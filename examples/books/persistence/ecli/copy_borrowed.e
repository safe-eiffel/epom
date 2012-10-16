note

	
		description: "Get the borrowed copies"
	
	status: "Cursor/Query automatically generated for 'COPY_BORROWED'. DO NOT EDIT!"
	generated: "2012/10/16 08:34:16.578"
	generator_version: "v1.7"
	source_filename: "C:\User\Eiffel\Dev\github\epom\examples\books\persistence\ecli\copy.xml"

class COPY_BORROWED

inherit

	ECLI_CURSOR


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
			create item.make
			create buffers.make (1,0)
			buffers.force (item.isbn, 1)
			buffers.force (item.serial_number, 2)
			set_results (buffers)
		end

end
