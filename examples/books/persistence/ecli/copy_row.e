note

	description: "Buffer objects for database transfer."
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2013/06/20 17:52:20.859"
	generator_version: "v1.7.2"
	source_filename: "copy.xml"

class COPY_ROW

create

	make

feature {NONE} -- Initialization

	make
			-- Creation of buffers
		do
			create isbn.make (14)
			create serial_number.make
			create loc_store.make
			create loc_shelf.make
			create loc_row.make
			create borrower.make
		ensure
			isbn_is_null: isbn.is_null
			serial_number_is_null: serial_number.is_null
			loc_store_is_null: loc_store.is_null
			loc_shelf_is_null: loc_shelf.is_null
			loc_row_is_null: loc_row.is_null
			borrower_is_null: borrower.is_null
		end

feature  -- Access

	isbn: ECLI_VARCHAR

	serial_number: ECLI_INTEGER

	loc_store: ECLI_INTEGER

	loc_shelf: ECLI_INTEGER

	loc_row: ECLI_INTEGER

	borrower: ECLI_INTEGER

end
