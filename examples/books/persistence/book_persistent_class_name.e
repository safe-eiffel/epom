indexing
	description: "Names of persistent book classes"
	author: "Paul G. Crismer"
	date: "$Date$"
	revision: "$Revision$"

class
	BOOK_PERSISTENT_CLASS_NAME

inherit
	STRING
		rename
			make as make_string
		end
	
creation
	make
	
creation
	{STRING} make_string
		
feature -- Initialization

	make is
		do
			make_from_string (name_constant)
		end
		
feature -- Constants

	name_constant : STRING is "BOOK"
	
invariant
	book_name: string.is_equal (name_constant)
	
end -- class BOOK_PERSISTENT_CLASS_NAME
