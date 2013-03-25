note

	description:

		"Objects that can persist on some datastore."

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class PO_PERSISTENT

inherit

	PO_SHARED_MANAGER

	PO_STATUS_USE
	PO_STATUS_MANAGEMENT

feature {PO_PERSISTENT, PO_REFERENCE, PO_ADAPTER, PO_CACHE, PO_ERROR} -- Access

	frozen pid : detachable PO_PID
		-- Persistence identifier, if any.

	frozen attached_pid : PO_PID
			-- Attached persistence identifier
		require
			is_persistent: is_persistent
		do
			check attached pid as l_result then
				Result := l_result
			end
		end

feature -- Access

	persistence_error_meaning : STRING
			-- Error meaning, if any.
		obsolete "use `status.message' instead"
		require
			status.is_error
		do
			Result := status.message
		end

	persistent_class_name : STRING
		-- Name of class for persistence. .
		-- To be redefined when a single adapter takes care of
		-- a whole class hierarchy (different classes, same persistent class name)
		deferred
		end

feature -- Status report

	is_persistent : BOOLEAN
			-- does Current have a persistent image on datastore ?
		do
			Result := (pid /= Void)
		ensure
			definition: Result implies pid /= Void
		end

	is_volatile : BOOLEAN
			-- does Current have no persistent image on datastore ?
		do
			Result := (pid = Void)
		ensure
			definition: Result = not is_persistent
		end

	is_deleted : BOOLEAN
			-- has Current's persistent image been deleted from datastore ?
		do
			Result := deleted_impl
		end

	is_modified : BOOLEAN
			-- has Current been modified since last persistence operation ?
		do
			Result := modified_impl
		end

	is_persistence_error : BOOLEAN
			-- has last persistence operation given an error ?
		obsolete "use `status.is_error"
		do
			Result := status.is_error
		end

	exists : BOOLEAN
			-- Does current object exist in datastore ?
		do
			if is_persistent then
				Result := True
			elseif is_deleted then
				Result := False
			elseif is_volatile then
				if attached {PO_ADAPTER[like Current]} adapter_for_me as adapter then
					Result := adapter.exists (adapter.pid_for_object (Current))
				end
			end
		end

	is_writable : BOOLEAN
			-- Is Current writable on datastore?
		local
			adapter : like adapter_for_me
		do
			adapter := adapter_for_me
			Result := adapter /= Void and then adapter.can_write
		end

	is_updatable : BOOLEAN
			-- Is Current updatable on datastore?
		local
			adapter :  like adapter_for_me
		do
			adapter := adapter_for_me
			Result := adapter /= Void and then adapter.can_update
		end

	is_refreshable : BOOLEAN
			-- Is Current refreshable from datastore?
		local
			adapter :  like adapter_for_me
		do
			adapter := adapter_for_me
			Result := adapter /= Void and then adapter.can_refresh
		end

	is_deletable : BOOLEAN
			-- Is Current deletable on datastore?
		local
			adapter :  like adapter_for_me
		do
			adapter := adapter_for_me
			Result := adapter /= Void and then adapter.can_delete
		end

feature {PO_ADAPTER} -- Status setting

	set_deleted
			-- Set `is_deleted'.
		require
			is_persistent: is_persistent
		do
			deleted_impl := True
			pid := Void
		ensure
			is_deleted: is_deleted
			is_volatile: is_volatile
		end

feature  {PO_ADAPTER } -- Element change

	set_pid (p : PO_PID )
			-- Set `pid' to `p'.
		require
			p_not_void: p /= Void
			same_persistent_class_names : p.persistent_class_name.is_equal (persistent_class_name)
		do
			pid := p
		ensure
			shared_pid: pid = p
			same_class_names: equal (persistent_class_name, pid.persistent_class_name)
		end

	disable_modified
			-- Set `is_modified' to False.
		do
			set_modified (False)
		ensure
			fresh: not is_modified
		end

feature -- Conversion

feature -- Basic operations

	write
			-- Write current object state to data store.
		require
			has_adapter: persistence_manager.has_adapter (persistent_class_name)
			volatile: is_volatile
			writable: is_writable
		do
			if attached {PO_ADAPTER[like Current]} adapter_for_me as adapter then
				adapter.write (Current)
				status.copy (adapter.status)
			else
				status.copy (persistence_manager.status)
			end
		ensure
			definition: not status.is_error implies (is_persistent and then exists and then not is_modified)
		end

	update
			-- Update data store from current object state.
		require
			has_adapter: persistence_manager.has_adapter (persistent_class_name)
			persistent: is_persistent
			updatable: is_updatable
		do
			if attached {PO_ADAPTER[like Current]} adapter_for_me as adapter then
				adapter.update (Current)
				status.copy (adapter.status)
			else
				status.copy (persistence_manager.status)
			end
		ensure
			definition: not status.is_error implies not is_modified
		end

	delete
			-- Delete current object state from data store.
		require
			has_adapter: persistence_manager.has_adapter (persistent_class_name)
			persistent: is_persistent
			deletable: is_deletable
		do
			if attached {PO_ADAPTER[like Current]} adapter_for_me as adapter then
				adapter.delete (Current)
				status.copy (adapter.status)
			else
				status.copy (persistence_manager.status)
			end
		ensure
			deleted: not status.is_error implies is_deleted and then not exists
			volatile: not status.is_error implies is_volatile
		end

	refresh
			-- Delete current object state from data store.
		require
			has_adapter: persistence_manager.has_adapter (persistent_class_name)
			persistent: is_persistent
			refreshable: is_refreshable
		do
			if attached {PO_ADAPTER[like Current]} adapter_for_me as adapter then
				adapter.refresh (Current)
				status.copy (adapter.status)
			else
				status.copy (persistence_manager.status)
			end
		ensure
			definition: not status.is_error implies not is_modified
		end

feature {NONE} -- Implementation

	adapter_for_me : detachable PO_ADAPTER[like Current]
		local
			persistent_name : STRING
		do
			if pid = Void then
				persistent_name := persistent_class_name
			else
				persistent_name := pid.persistent_class_name
			end
			persistence_manager.search_adapter (persistent_name)
			if persistence_manager.found then
				Result ?= persistence_manager.last_adapter
			else
				persistence_manager.error_handler.report_could_not_find_adapter (persistent_name, generator, "adapter_for_me")
			end
		ensure
			result_not_void_if_adapter_registered: Result /= Void implies persistence_manager.has_adapter (persistent_class_name)
		end

	set_modified (value : BOOLEAN)
			-- Set `is_modified' to `value'.
		do
			modified_impl := Value
		end
	modified_impl : BOOLEAN

	deleted_impl : BOOLEAN

invariant

	persistent_has_a_pid: is_persistent implies pid /= Void
	persistent_class_name_not_void: persistent_class_name /= Void and then not persistent_class_name.is_empty
	volatile_and_persistent_state_are_exclusive: is_volatile xor is_persistent
	deleted_implies_volatile: is_deleted implies is_volatile

end
