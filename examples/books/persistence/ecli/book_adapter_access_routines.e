note

	description:"Generated access routines"
	status: "Automatically generated.  DOT NOT MODIFY !"
	generated: "2012/10/16 08:36:50.421"
	generator_version: "v1.7"
	source_filename: "C:\User\Eiffel\Dev\github\epom\examples\books\persistence\ecli\book.xml"
	usage: "mix-in"

deferred class BOOK_ADAPTER_ACCESS_ROUTINES

inherit

	PO_STATUS_USE
	PO_STATUS_MANAGEMENT

feature  -- Access

	last_object: detachable PO_PERSISTENT
		deferred
		end

	last_cursor: PO_CURSOR[attached like last_object]
		deferred
		end

feature  -- Status report

	is_error: BOOLEAN
			-- Did last operation produce an error?
		deferred
		end

feature  -- Basic operations

	book_read_by_title (title: STRING)
		require
			refine_in_descendants: False
		deferred
		end

feature {NONE} -- Implementation

	do_book_read_by_title (cursor: BOOK_READ_BY_TITLE; title: STRING)
			-- helper implementation of access `BOOK_READ_BY_TITLE'
		require
			cursor_not_void: cursor /= Void
			last_cursor_empty: last_cursor /= Void and then last_cursor.is_empty
		local
			parameters: BOOK_READ_BY_TITLE_PARAMETERS
		do
			create parameters.make
			parameters.title.set_item (title)
			cursor.set_parameters_object (parameters)
			from
				cursor.start
				status.reset
			until
				status.is_error or else not cursor.is_ok or else cursor.off
			loop
				extend_cursor_from_book_row (cursor.item)
				cursor.forth
			end
			if cursor.is_error then
				status.set_datastore_error (cursor.native_code, cursor.diagnostic_message)
			elseif cursor.is_ok and cursor.has_information_message then
				status.set_datastore_warning (cursor.native_code, cursor.diagnostic_message)
			end
		end

	extend_cursor_from_book_row (row: BOOK_ROW)
		require
			row_not_void: row /= Void
			last_cursor_not_void: last_cursor /= Void
		deferred
		ensure
			last_cursor_extended: not is_error implies (last_cursor.count = old (last_cursor.count) + 1)
		end

end
