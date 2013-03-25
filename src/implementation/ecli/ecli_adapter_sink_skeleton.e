note

	description:

		"[
			Adapters using ECLI that implement 
			- all framework accesses as no-operation
			- error_handler and create_error_handler
		]"

	copyright: "Copyright (c) 2004-today, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_ADAPTER_SINK_SKELETON[G->PO_PERSISTENT]

inherit

	ECLI_ADAPTER_COMMON_SKELETON[G]

feature {NONE} -- Framework - Access

	error_handler : PO_ECLI_ERROR_HANDLER

feature -- Status report

	can_write : BOOLEAN do Result := False end
	can_update : BOOLEAN do Result := False end
	can_delete : BOOLEAN do Result := False end
	can_refresh : BOOLEAN do Result := False end
	can_read : BOOLEAN do Result := False end

feature -- Basic operations

	read (pid: like last_pid)
		do
			do_nothing
		end

	update (object: attached like object_anchor)
		do
			do_nothing
		end

	refresh (object: attached like object_anchor)
		do
			do_nothing
		end

	write (object: attached like object_anchor)
		do
			do_nothing
		end

	delete (object: attached like object_anchor)
		do
			do_nothing
		end

feature {PO_DATASTORE} -- Framework - Basic operations

	on_adapter_connected
		do
			do_nothing
		end

	on_adapter_disconnect
		do
			do_nothing
		end

	create_error_handler
		do
			create error_handler.make_standard
		end

end
