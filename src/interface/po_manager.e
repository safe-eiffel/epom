note

	description:

		"Objects that are brokers for persistence adapters."

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class PO_MANAGER

inherit

	PO_STATUS_USE
	PO_STATUS_MANAGEMENT

feature -- Access

	last_adapter : detachable PO_ADAPTER [PO_PERSISTENT]
			-- Last adapter found by `search_adapter'.

	adapters : DS_LIST[PO_ADAPTER[PO_PERSISTENT]]
			-- Known adapters.
		deferred
		end

	error_handler : PO_ERROR_HANDLER
		deferred
		end


feature -- Measurement

	count : INTEGER
			-- Number of known adapters.
		deferred
		end

feature -- Status report

	found : BOOLEAN
			-- Has the last search_adapter operation succeeded ?
		deferred
		ensure
			status: not Result implies status.is_error
		end

	has_adapter (persistent_class_name : STRING) : BOOLEAN
			-- Has the POM an adapter for  `class_name'?
		require
			class_name_not_void: persistent_class_name /= Void
		deferred
		ensure
			side_effect: Result implies (last_adapter /= Void and then last_adapter.persistent_class_name.is_equal (persistent_class_name))
		end

feature {PO_LAUNCHER} -- Status setting

	add_adapter (an_adapter : PO_ADAPTER[PO_PERSISTENT])
			-- Add `an_adapter'.
		require
			adapter_not_void: an_adapter /= Void
			no_adapter_for_class: not has_adapter (an_adapter.persistent_class_name)
		deferred
		ensure
			registered: has_adapter (an_adapter.persistent_class_name)
			inserted: adapters.has (an_adapter) and then count = old count + 1
		end

	set_error_handler (an_error_handler : PO_ERROR_HANDLER)
			-- Set `error_handler' to `an_error_handler'.
		require
			an_error_handler_not_void: an_error_handler /= Void
		deferred
		ensure
			error_handler_set: error_handler /= Void
		end

feature -- Basic operations

	search_adapter (persistent_class_name : STRING)
			-- Search of adapter for class of `class_name'.
		require
			class_name_not_void: persistent_class_name /= Void
		deferred
		ensure
			found_definition : found implies (last_adapter /= Void and then last_adapter.persistent_class_name.is_equal (persistent_class_name))
		end

invariant

	adapters_collection_not_void: adapters /= Void
	error_handler_not_void: error_handler /= Void
end
