note

	description:

		"Objects that share a single PO_MANAGER."

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class PO_SHARED_MANAGER

feature -- Access

	persistence_manager : PO_MANAGER
			-- Persistence manager singleton.
		local
			l_res : detachable like persistence_manager
		do
			l_res := shared_po_manager_cell.item
			check l_res /= Void end
			Result := l_res
		ensure
			Result /= Void
		end

feature {PO_LAUNCHER} -- Status setting

	set_manager (manager : PO_MANAGER)
			-- Set `persistence_manager' to `manager'.
		require
			manager_not_void: manager /= Void
		do
			shared_po_manager_cell.put (manager)
		ensure
			persistence_manager_set: persistence_manager = manager
		end

feature {NONE} -- Implementation

	shared_po_manager_cell : DS_CELL[detachable PO_MANAGER]
			-- The singleton.
		once ("PROCESS")
			create Result.make (Void)
		end

invariant

	cell_not_void: shared_po_manager_cell /= Void

end
