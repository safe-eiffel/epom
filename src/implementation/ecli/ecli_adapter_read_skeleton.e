note

	description:

		"Adapters using ECLI that implement read access"

	copyright: "Copyright (c) 2004-2012, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class ECLI_ADAPTER_READ_SKELETON[G->PO_PERSISTENT]

inherit

	ECLI_ADAPTER_COMMON_SKELETON[G]

feature -- Status report

	can_read : BOOLEAN
		do
			Result := True
		ensure then
			can_read: Result
		end

feature -- Basic operations

	read (a_pid: like last_pid)
			-- Read an object identified by `a_pid' using `read_cursor'.
		do
			last_object := default_value
			create last_cursor.make
			status.reset
			if is_enabled_cache_on_read then
				cache.search (a_pid)
				if cache.found then
					if attached cache.found_item as l_item then
						last_cursor.add_object (l_item)
					end
				end
			end
			if not is_enabled_cache_on_read or else not cache.found then
				if attached {attached like last_pid} a_pid as l_pid and then attached read_cursor as l_read_cursor then
					init_parameters_for_read (l_pid)
					read_cursor.execute
					if read_cursor.is_ok then
						load_results (read_cursor, a_pid)
					else
						status.set_datastore_error (l_read_cursor.native_code, l_read_cursor.diagnostic_message)
						error_handler.report_datastore_error (generator, "read", l_read_cursor.native_code, l_read_cursor.diagnostic_message)
					end
				else
					status.set_framework_error (status.error_non_conformant_pid)
					error_handler.report_non_conformant_pid (generator, "read", "[like last_pid]", a_pid.generator)
				end
			end
		end

feature {NONE} -- Framework - Access

	read_cursor : detachable ECLI_CURSOR
		deferred
		end

feature {NONE} -- Framework - Basic operations

	init_parameters_for_read (a_pid : like last_pid)
			-- Initialize parameters of `read_cursor' with information from `a_pid'.
		require
			a_pid_not_void: a_pid /= Void
		deferred
		ensure
			bound_parameters: read_cursor.has_parameters implies read_cursor.bound_parameters
		end

feature {NONE} -- Framework - Factory

	create_object_from_read_cursor  (a_cursor : like read_cursor; a_pid : like last_pid)
			-- Create object and just ensure invariant.
		require
			last_object_void: last_object = Void
			a_cursor_not_void: a_cursor /= Void
			a_pid_not_void: a_pid /= Void
			something_read : not a_cursor.off
		deferred
		ensure
			last_object_created_if_no_error: not status.is_error implies last_object /= Void
		end

	fill_object_from_read_cursor (a_cursor : like read_cursor; object : like last_object)
			-- Fill `last_object' using `read_cursor' results.
		require
			a_cursor_not_void: a_cursor /= Void
			object_not_void: object /= Void
		deferred
		end

feature {NONE} -- Implementation

	load_results (a_cursor : like read_cursor; a_pid : like last_pid)
			-- Load results from a cursor.
		require
			a_cursor_not_void: a_cursor /= Void
			a_cursor_executed: a_cursor.is_executed
			a_cursor_before: a_cursor.before  --<<>>--
			a_pid_not_void: a_pid /= Void
		do
			a_cursor.start
			if a_cursor.is_ok then
				if not a_cursor.off then
					create_object_from_read_cursor (a_cursor, a_pid)
					if attached last_object as l_object then
						fill_object_from_read_cursor (a_cursor, l_object)
						if status.is_ok then
							l_object.set_pid (a_pid)
							if is_enabled_cache_on_read then
								cache.put (l_object)
							end
							last_cursor.add_object (l_object)
							a_cursor.go_after
						else
							last_cursor.wipe_out
						end
					else
						status.set_framework_error (status.error_could_not_create_object)
						error_handler.report_could_not_create_object (generator, "read", persistent_class_name)
					end
				else
					if is_enabled_cache_on_read then
						cache.put_void (a_pid)
					end
				end
			else
				status.set_datastore_error (a_cursor.native_code, a_cursor.diagnostic_message)
				error_handler.report_datastore_error (generator, "load_results", a_cursor.native_code, a_cursor.diagnostic_message)
			end
		end

end
