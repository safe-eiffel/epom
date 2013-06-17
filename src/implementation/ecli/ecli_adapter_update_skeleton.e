note

	description:

		"Adapters using ECLI that implement update access"

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_ADAPTER_UPDATE_SKELETON[G->PO_PERSISTENT]

inherit

	ECLI_ADAPTER_COMMON_SKELETON[G]

feature -- Access report

	can_update : BOOLEAN
		do
			Result := True
		ensure then
			can_update: Result
		end

feature -- Basic operations

	update (object: attached like object_anchor)
			-- Update `object' on datastore using `update_query'.
		local
			default_pid: detachable like last_pid
		do
			status.reset
			if object.is_volatile then
				create_pid_from_object (object)
			else
				if attached {detachable like last_pid} object.pid as l_pid then
					last_pid := l_pid
				else
					last_pid := default_pid
				end
			end

			last_object := default_value
			if attached last_pid as l_pid then
				init_parameters_for_update (object, l_pid)
				update_query.execute
				if update_query.is_ok then
					object.set_pid (l_pid)
					object.disable_modified
				else
					--| query failed
					status.set_datastore_error (update_query.native_code, update_query.diagnostic_message)
					error_handler.report_datastore_error (generator, "update", update_query.native_code, update_query.diagnostic_message)
				end
			else
				--| non_conformant_pid
				status.set_framework_error (status.error_non_conformant_pid)
				error_handler.report_non_conformant_pid (generator, "update", persistent_class_name, object.persistent_class_name)
			end
		end

feature {NONE} -- Framework - Access

	update_query : detachable ECLI_QUERY
		deferred
		end

feature {NONE} -- Framework - Basic operations

	init_parameters_for_update (object : attached like last_object; a_pid : attached like last_pid)
			-- Initialize parameters of `update_query' with information from `object' and `a_pid'.
		require
			object_not_void: object /= Void
			a_pid_not_void: a_pid /= Void
		deferred
		end

end
