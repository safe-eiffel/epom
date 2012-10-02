indexing

	description:

		"Objects that use a Persistence Operations Status"

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

class PO_STATUS_USE

feature -- Access

	status : PO_STATUS is
			-- Status related to latest persistance operation.
		do
			if attached impl_status as l_result then
				Result := l_result
			else
				create Result
				impl_status := Result
			end
		end

feature {NONE} -- Implementation

	impl_status : detachable like status

invariant

	status_not_void: status /= Void --FIXME: VS-DEL

end
