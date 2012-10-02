indexing

	description:

		"Adapters using ECLI that implement delete access"

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_ADAPTER_DELETE_SKELETON[G->PO_PERSISTENT]

inherit

	ECLI_ADAPTER_COMMON_SKELETON[G]

feature -- Status report

	can_delete : BOOLEAN is
		do
			Result := True
		ensure then
			can_delete: Result
		end

feature -- Basic operations

	delete (object: attached like object_anchor) is
			-- Delete `object' from datastore using `delete_query'.
		local
			default_pid : like last_pid
		do
			status.reset
			if attached {attached like last_pid} pid_for_object (object) as l_pid then
				last_pid := l_pid
			else
				last_pid := default_pid
			end

			last_object := default_value
			if attached {attached like last_pid} pid_for_object (object) as l_pid and then attached delete_query as l_delete_query then
				init_parameters_for_delete (l_pid)
				l_delete_query.execute
				if l_delete_query.is_ok then
					status.reset
					cache.search (l_pid)
					if cache.found then
						cache.remove (l_pid)
					end
					object.set_deleted
				else
					status.set_datastore_error (l_delete_query.native_code, l_delete_query.diagnostic_message)
					error_handler.report_query_error (generator, "delete", l_delete_query)
				end
			else
				status.set_framework_error (status.error_non_conformant_pid)
				error_handler.report_non_conformant_pid (generator, "delete", persistent_class_name, object.persistent_class_name)
			end
		end

feature {NONE} -- Framework - Access

	delete_query : detachable ECLI_QUERY is
		deferred
		end

feature {PO_ADAPTER} -- Framework - Basic operations

	init_parameters_for_delete (a_pid : attached like last_pid) is
			-- Initialize parameters of `delete_query' with information from `a_pid'.
		require
			a_pid_not_void: a_pid /= Void
		deferred
		ensure
			bound_parameters: delete_query.bound_parameters
		end

end
