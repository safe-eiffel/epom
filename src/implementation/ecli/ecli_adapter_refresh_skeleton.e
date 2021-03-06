note

	description:

		"Adapters using ECLI that implement refresh access"

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_ADAPTER_REFRESH_SKELETON[G->PO_PERSISTENT]

inherit

	ECLI_ADAPTER_COMMON_SKELETON[G]

feature -- Status report

	can_refresh : BOOLEAN
		do
			Result := True
		ensure then
			can_refresh: Result
		end

feature -- Basic operations

	refresh (object: attached like last_object)
			-- Refresh `object' using `refresh_cursor'.
		local
			default_pid: detachable like last_pid
		do
			status.reset
			last_pid := default_pid
			if attached {attached like last_pid} object.pid as l_pid and attached refresh_cursor as l_refresh_cursor then
				last_pid := l_pid
				init_parameters_for_refresh (l_pid)
				l_refresh_cursor.start
				if l_refresh_cursor.is_ok then
					if not l_refresh_cursor.off then
						fill_from_refresh_cursor (object)
						if not status.is_error then
							object.disable_modified
						end
					else
						status.set_framework_error (status.Error_could_not_refresh_object)
						error_handler.report_could_not_refresh_object (generator, object)
					end
				else
					status.set_datastore_error (refresh_cursor.native_code, refresh_cursor.diagnostic_message)
					error_handler.report_datastore_error (generator, "refresh", refresh_cursor.native_code, refresh_cursor.diagnostic_message)
				end
			else
				status.set_framework_error (status.Error_non_conformant_pid)
				error_handler.report_non_conformant_pid (generator, "refresh", persistent_class_name, object.persistent_class_name)
			end
		end

feature {PO_ADAPTER} -- Basic operations

	init_parameters_for_refresh (a_pid : like last_pid)
			-- Initialize parameters of `refresh_cursor' with information from `a_pid'.
		require
			refresh_cursor_not_void: refresh_cursor /= Void
		deferred
		ensure
			bound_parameters: refresh_cursor.bound_parameters
		end

	fill_from_refresh_cursor (object : attached like last_object)
			-- Fill `last_object' using `refresh_cursor' results.
		require
			refresh_cursor_not_void: refresh_cursor /= Void
			object_not_void: object /= Void
		deferred
		end

feature {PO_ADAPTER} -- Implementation

	refresh_cursor : detachable ECLI_CURSOR
		deferred
		end

end
