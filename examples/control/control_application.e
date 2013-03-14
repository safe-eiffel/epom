class
	CONTROL_APPLICATION

create
	make

feature -- Initialization

	make
		do
			create po_error.make_connection_error ("nom", 33, "message")
			create po_error_handler.make_standard
			create po_launcher
			create po_status_use
			create po_status_management
			create po_status
			create po_shared_manager
			create po_reference_access
			create po_reference.make_void
--			create po_serial_pid.make_serial_unsafe (22,"toto")
			create po_reference_list_cursor.make
			create po_manager_impl.make
			create po_lru_hashed_cache.make (10)
			create po_hashed_cache.make (10)
--			create po_lru_entry.make (po_serial_pid)
--			create po_cache_use
			create po_adapter_error_codes
			create po_ecli_error_handler.make_standard
--			create po_ecli_error.make_query_error ("toto", "toto", ecli_query)
			create ecli_datastore.make (create {ECLI_SESSION}.make_default)
			do_test_ecli_adapter
		end

	do_test_ecli_adapter
		local
			simple : detachable ECLI_SIMPLE_ADAPTER[PO_PERSISTENT]
			general: detachable ECLI_GENERAL_ADAPTER[PO_PERSISTENT]
		do
			if attached simple as att_simple then
				do_test_simple (att_simple)
			end
		end

	do_test_simple (simple : ECLI_SIMPLE_ADAPTER[PO_PERSISTENT])
		do
			if simple.is_enabled_cache_on_read then

			end
		end

feature -- Access


--	 po_adapter : PO_ADAPTER[PO_PERSISTENT]
--	 po_cache : PO_CACHE[PO_PERSISTENT]
--	 po_cursor : PO_CURSOR[PO_PERSISTENT]
--	 po_datastore : PO_DATASTORE
	 po_error : PO_ERROR
	 po_error_handler : PO_ERROR_HANDLER
--	 po_generic_pid : PO_GENERIC_PID[PO_PERSISTENT]
	 po_launcher : PO_LAUNCHER
--	 po_manager : PO_MANAGER
--	 po_persistent : PO_PERSISTENT
--	 po_pid : PO_PID
	 po_reference : PO_REFERENCE[PO_PERSISTENT]
	 po_reference_access : PO_REFERENCE_ACCESS
	 po_shared_manager : PO_SHARED_MANAGER
	 po_status : PO_STATUS
	 po_status_management : PO_STATUS_MANAGEMENT
	 po_status_use : PO_STATUS_USE

	 po_adapter_error_codes : PO_ADAPTER_ERROR_CODES
--	 po_cache_use : PO_CACHE_USE [PO_PERSISTENT]
	 po_hashed_cache : PO_HASHED_CACHE[PO_PERSISTENT]
--	 po_lru_entry : PO_LRU_ENTRY
	 po_lru_hashed_cache : PO_LRU_HASHED_CACHE[PO_PERSISTENT]
	 po_manager_impl : PO_MANAGER_IMPL
	 po_reference_list_cursor : PO_REFERENCE_LIST_CURSOR[PO_PERSISTENT]
--	 po_serial_pid : PO_SERIAL_PID [PO_PERSISTENT]

--	 ecli_adapter_common_skeleton : ECLI_ADAPTER_COMMON_SKELETON [PO_PERSISTENT]
--	 ecli_adapter_delete_skeleton : ECLI_ADAPTER_DELETE_SKELETON [PO_PERSISTENT]
--	 ecli_adapter_read_collection_skeleton : ECLI_ADAPTER_READ_COLLECTION_SKELETON [PO_PERSISTENT]
--	 ecli_adapter_read_exists_skeleton : ECLI_ADAPTER_READ_EXISTS_SKELETON [PO_PERSISTENT]
--	 ecli_adapter_read_skeleton : ECLI_ADAPTER_READ_SKELETON [PO_PERSISTENT]
--	 ecli_adapter_refresh_skeleton : ECLI_ADAPTER_REFRESH_SKELETON [PO_PERSISTENT]
--	 ecli_adapter_sink_skeleton : ECLI_ADAPTER_SINK_SKELETON [PO_PERSISTENT]
--	 ecli_adapter_update_skeleton : ECLI_ADAPTER_UPDATE_SKELETON [PO_PERSISTENT]
--	 ecli_adapter_write_skeleton : ECLI_ADAPTER_WRITE_SKELETON [PO_PERSISTENT]
	 ecli_datastore : ECLI_DATASTORE
--	 ecli_general_adapter : ECLI_GENERAL_ADAPTER [PO_PERSISTENT]
--	 ecli_simple_adapter : ECLI_SIMPLE_ADAPTER [PO_PERSISTENT]
--	 po_ecli_error : PO_ECLI_ERROR
	 po_ecli_error_handler : PO_ECLI_ERROR_HANDLER

end
