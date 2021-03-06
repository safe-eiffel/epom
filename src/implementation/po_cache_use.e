note

	description:

		"Objects that use a PO_CACHE."

	nota_bene: "Class existing because of a refactoring.  May disappear in the future."

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class
	PO_CACHE_USE [G -> PO_PERSISTENT]

feature -- Initialization

	make_cache
		deferred
		ensure
			cache_created: cache /= Void
		end
		
feature -- Status report

	is_cached (object : G) : BOOLEAN
		do
			Result := cache.has_item (object)
		end

feature {PO_ADAPTER} -- Basic operations

	clear_cache
		do
			cache.wipe_out
		end

feature {NONE} -- Implementation

	cache : PO_CACHE[G]

invariant

	cache_not_void: cache /= Void

end -- class PO_CACHE_USE
