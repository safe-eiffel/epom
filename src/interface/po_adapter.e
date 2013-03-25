note

	description:

		"Objects that handle all accesses to persistent objects of type G on a datastore.%N%
		% %
		%The persistent objects all have `persistent_class_name' as persistence name.%N%
		% %
		%Adapters are factories for read objects, which are put into `last_cursor'."

	author: "Paul G. Crismer"

	implementation_note: " %
		%	- implement needed accesses %
		%		- `read', `can_read' %
		%		- `write', `can_write' %
		%		- `update', `can_update' %
		%		- `refresh', `can_refresh' %
		%		- `delete', `can_delete' %
		%	- implement factories %
		%		- `create_pid_from_object', `last_pid' %
		%		- creation of `last_object'  %
		%		- inserting `last_object' into `last_cursor' %
		%	- redefine, if needed %
		%		- `on_adapter_connected' %
		%		- `on_adapter_disconnect' %
		% "


	Usage: "Inherit.  Define all deferred features."
	date: "$Date$"
	revision: "$Revision$"

deferred class PO_ADAPTER [G -> PO_PERSISTENT]

inherit

	PO_STATUS_USE
	PO_STATUS_MANAGEMENT

feature -- Access

	class_name: STRING
		obsolete "[2004-08-26] Use `persistent_class_name' instead."
		do
			Result := persistent_class_name
		end

	persistent_class_name : STRING
			-- Persistence class name of objects that this adapter can handle.
		deferred
		end

	datastore : PO_DATASTORE
			-- Datastore on which I/O operations will occur.
		deferred
		end

	last_cursor : PO_CURSOR [G]
			-- Last cursor on objects that have been read.
		deferred
		end

	object_anchor : detachable G do end

	pid_for_object (object : attached like object_anchor) : PO_PID
			-- Persistent identifier for `object'.
		require
			object_not_void: object /= Void
		do
			if object.is_persistent then
				Result := object.attached_pid
			else
				create_pid_from_object (object)
				check attached last_pid as l_pid then
					Result := l_pid
				end
			end
		ensure
			definition: Result /= Void
			pid_of_persistent: object.is_persistent implies Result = object.pid
			created_for_volatile: object.is_volatile implies Result = last_pid
		end

	error_handler : PO_ERROR_HANDLER
		deferred
		end

feature {PO_ADAPTER, PO_CURSOR, PO_REFERENCE, PO_PERSISTENT, PO_REFERENCE_ACCESS} -- Framework - Access

	last_pid : detachable PO_PID
			-- Last PID created by factory features.
		deferred
		end

	attached_last_pid : attached like last_pid
		do
			check attached last_pid as l_result then
				Result := l_result
			end
		end

feature {PO_ADAPTER} -- Framework - Access

	last_object : detachable G
			-- Last object created by factory features.
		deferred
		ensure
		end

	attached_last_object: attached like last_object
		do
			check attached last_object as l_object then
				Result := l_object
			end
		end
feature -- Measurement

	cache_count : INTEGER
			-- Number of objects in cache.
		deferred
		end

feature -- Status report

	is_error : BOOLEAN
			-- is the last operation in error ?
		obsolete "use `status.is_error' instead"
		do
			Result := status.is_error
		end

	is_ok : BOOLEAN
			-- is the last operation ok ?
		obsolete "use `status.is_ok' instead"
		do
			Result := status.is_ok
		end

	is_pid_valid (some_pid : PO_PID): BOOLEAN
			-- Is `some_pid' a valid pid ?
		require
			some_pid_not_void: some_pid /= Void
		do
			Result := some_pid.persistent_class_name.is_equal (persistent_class_name)
		end

	no_data_found : BOOLEAN
			-- have no data been found ?
		do
			Result := (last_cursor.count = 0)
		ensure
			definition: Result = (last_cursor.count = 0)
		end

	can_read : BOOLEAN
			-- does this adapter implement read access ?
		deferred
		end

	can_refresh : BOOLEAN
			-- does this adapter implement refresh access ?
		deferred
		end

	can_write : BOOLEAN
			-- does this adapter implement write access ?
		deferred
		end

	can_update : BOOLEAN
			-- does this adapter implement update access ?
		deferred
		end

	can_delete : BOOLEAN
			-- does this adapter implement delete access ?
		deferred
		end

	is_enabled_cache_on_write : BOOLEAN
			-- Are written objects inserted in cache ?
		deferred
		end

	is_enabled_cache_on_read : BOOLEAN
			-- Are read objects inserted in cache ?
		deferred
		end

feature -- Status setting

	reset_error
			-- Reset `is_error' so that operations can continue.
		obsolete "use `status.reset' instead."
		do
			status.reset
		ensure
			not_is_error: not is_error
		end

	enable_cache_on_read
			-- Cache objects after they have been read.
		deferred
		ensure
			definition: is_enabled_cache_on_read
		end

	disable_cache_on_read
			-- Do not cache objects after they have been read.
		deferred
		ensure
			definition: not is_enabled_cache_on_read
		end

	enable_cache_on_write
			-- Cache objects after they have been written.
		deferred
		ensure
			definition: is_enabled_cache_on_write
		end

	disable_cache_on_write
			-- Do not cache objects after they have been written.
		deferred
		ensure
			definition: not is_enabled_cache_on_write
		end

feature {PO_LAUNCHER} -- Element change

	set_datastore (a_datastore : PO_DATASTORE)
			-- Attach to `a_datastore'.
		require
			a_datastore_not_void: a_datastore /= Void
		deferred
		ensure
			datastore_set: datastore = a_datastore
			adapter_registered_to_datastore: datastore.adapters.has (Current)
		end

feature -- Basic operations

	exists (pid : PO_PID) : BOOLEAN
			-- Does an object identifed by `pid' exist in datastore ?
		require
			pid_not_void: pid /= Void
			pid_is_valid_pid: is_pid_valid (pid)
			datastore_connected: datastore.is_connected
			is_ok: status.is_ok
		deferred
		end

	read (pid : like last_pid)
			-- Read a persistent object using identifier `pid'.
		require
			can_read: can_read
			pid_not_void: pid /= Void
			pid_is_valid_pid: is_pid_valid (pid)
			datastore_connected: datastore.is_connected
			is_ok: status.is_ok
		deferred
		ensure
			last_cursor_not_void: last_cursor /= Void
			empty_cursor_when_error: status.is_error implies last_cursor.is_empty
			single_object_read: (not status.is_error and then not last_cursor.is_empty) implies last_cursor.count = 1
			object_cached: (not last_cursor.is_empty and then is_enabled_cache_on_read) implies is_cached (last_cursor.first)
		end

	write (object : attached like object_anchor)
			-- Write `o' on persistent datastore.
		require
			can_write: can_write
			object_not_void: object /= Void
			object_is_volatile: object.is_volatile
			object_not_in_datastore: not exists (pid_for_object (object))
			datastore_connected: datastore.is_connected
			is_ok: status.is_ok
		deferred
		ensure
			last_pid_created_and_set: not status.is_error implies object.pid = last_pid
			object_fresh: not status.is_error implies not object.is_modified
			object_persists: not status.is_error implies object.is_persistent
			object_cached: (not status.is_error and then is_enabled_cache_on_write) implies is_cached (object)
		end

	update (object : attached like object_anchor)
			-- Update `object' on persistent datastore.
		require
			can_update: can_update
			object_not_void: object /= Void
			object_updatable: object.is_persistent or else exists (pid_for_object (object))
			datastore_connected: datastore.is_connected
			is_ok: status.is_ok
		deferred
		ensure
			object_fresh: not status.is_error implies not object.is_modified
		end

	refresh (object : attached like object_anchor)
			-- Refresh `object' by reading its persistent state from datastore.
		require
			can_refresh: can_refresh
			object_not_void: object /= Void
			object_exists_in_datastore: object.is_persistent and exists (pid_for_object (object))
			datastore_connected: datastore.is_connected
			is_ok: status.is_ok
		deferred
		ensure
			object_fresh: not status.is_error implies not object.is_modified
		end

	delete (object : attached like object_anchor)
			--  Delete `object's persistent image.
		require
			can_delete: can_delete
			object_not_void: object /= Void
			object_already_in_store: exists (pid_for_object (object))
			datastore_connected: datastore.is_connected
			is_ok: status.is_ok
		deferred
		ensure
			object_deleted: not status.is_error implies (object.is_deleted and not exists (pid_for_object (object)))
			no_more_cached: not status.is_error implies not is_cached (object)
		end

	clear_cache
			-- Clear cache.
		deferred
		ensure
			cache_count_is_0 : cache_count = 0
		end

feature {PO_DATASTORE} -- Framework - Basic Operations

	on_adapter_connected
			-- Callback after adapter has been connected.
			-- * to be redefined in descendant classes
		do

		end

	on_adapter_disconnect
			-- Callback before adapter is disconnected.
			-- * to be redefined in descendant classes
		do

		end

feature -- Contract support

	is_cached (object : attached like object_anchor) : BOOLEAN
			-- Is `object' in cache ?
		require
			persistent_object: object /= Void
		deferred
		ensure
			is_cached_implies_is_persistent: Result implies object.is_persistent
		end

feature {PO_REFERENCE} -- Framework - Factory

	create_pid_from_object (an_object : attached like object_anchor)
			-- Create a pid from a volatile object.
		require
			object_not_void: an_object /= Void
			object_is_volatile: an_object.is_volatile
		deferred
		ensure
			exists_and_valid: not status.is_error implies (attached last_pid as l_pid and then is_pid_valid (l_pid))
		end

invariant

	class_name_defined: persistent_class_name /= Void and then not persistent_class_name.is_empty
	datastore_exists : datastore /= Void
	registered_to_datastore: datastore.adapters.has (Current)
	valid_last_pid: attached last_pid as l_pid implies is_pid_valid (l_pid)
	last_cursor_not_void: last_cursor /= Void
	error_handler_not_void: error_handler /= Void

end
