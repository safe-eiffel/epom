note

	description:

		"Access to persistence related objects of the BOOKS datastore"

	copyright: "Copyright (c) 2004, Paul G. Crismer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"

deferred class BOOKS_DATASTORE_ACCESS

inherit

	PO_SHARED_MANAGER
	PO_LAUNCHER

	KL_SHARED_STANDARD_FILES

feature {BOOKS_DATASTORE_ACCESS} -- Access

	book_adapter : BOOK_ADAPTER
		require
			is_persistence_framework_initialized: is_persistence_framework_initialized
		do
			check attached book_adapter_impl as l_result then
				Result := l_result
			end
		end

	copy_adapter : COPY_ADAPTER
		require
			is_persistence_framework_initialized: is_persistence_framework_initialized
		do
			check attached copy_adapter_impl as l_result then
				Result := l_result
			end
		end

	borrower_adapter : BORROWER_ADAPTER
		require
			is_persistence_framework_initialized: is_persistence_framework_initialized
		do
			check attached borrower_adapter_impl as l_result then
				Result := l_result
			end
		end

feature -- Status report

	is_persistence_framework_initialized : BOOLEAN

feature -- Basic operations

	initialize_persistence_framework (datasource_name, user_name, user_password : STRING)
		require
			not_initialized: not is_persistence_framework_initialized
		local
			session : ECLI_SESSION
			simple_login : ECLI_SIMPLE_LOGIN
			manager : PO_MANAGER_IMPL
			l_store : attached like store
			l_book_adapter : like book_adapter
			l_borrower_adapter : like borrower_adapter
			l_copy_adapter: like copy_adapter
			l_tracer : ECLI_TRACER
		do
			create session.make_default
			create simple_login.make(datasource_name, user_name, user_password)
			session.set_login_strategy (simple_login)
			create l_store.make (session)
			store := l_store
			l_store.connect
			if l_store.is_connected then
				create l_tracer.make (std.output)
				session.set_tracer (l_tracer)
				verify_table_existence
				if not table_exists then
					create_table
				end
				if table_exists then
					create manager.make
					set_manager (manager)
					create {BOOK_ADAPTER_ECLI}l_book_adapter.make (l_store)
					l_book_adapter.enable_cache_on_write
					l_book_adapter.enable_cache_on_read
					pom.add_adapter (l_book_adapter)
					book_adapter_impl := l_book_adapter
					create {BORROWER_ADAPTER_ECLI}l_borrower_adapter.make (l_store)
					pom.add_adapter (l_borrower_adapter)
					borrower_adapter_impl := l_borrower_adapter
					create {COPY_ADAPTER_ECLI}l_copy_adapter.make (l_store)
					pom.add_adapter (l_copy_adapter)
					copy_adapter_impl := l_copy_adapter
					is_persistence_framework_initialized := True

				else
					print ("Error: Expected tables do not exist%N")
				end
			else
				print ("Error connecting to database%N")
				print (store.session.diagnostic_message)
			end
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	book_adapter_impl : detachable BOOK_ADAPTER
	copy_adapter_impl : detachable COPY_ADAPTER
	borrower_adapter_impl : detachable BORROWER_ADAPTER

	verify_table_existence
		local
			cursor : ECLI_TABLES_CURSOR
			criteria : ECLI_NAMED_METADATA
		do
			create criteria.make (Void, Void, "book")
			create cursor.make (criteria, store.session)
			from
				cursor.start
			until
				cursor.off
			loop
				table_exists := True
				cursor.forth
			end
		end

	table_exists : BOOLEAN

	create_table
		local
			ddl : ECLI_STATEMENT
		do
			create ddl.make (store.session)
			ddl.set_sql (
	"[
		create table COPY (
			isbn varchar(14),
			serial_number integer,
			loc_store integer,
			loc_shelf integer,
			loc_row integer,
			borrower integer)
	]")
			ddl.execute
			if ddl.is_ok then
				ddl.set_sql (
	"[
		create table BORROWER (
			id integer,
			name varchar (30),
			address varchar (50))
	]")
				ddl.execute
				if ddl.is_ok then
					ddl.set_sql (
	"[
		create table BOOK (
			isbn varchar(14),
			title varchar(100),
			author varchar(30))
	]")
					ddl.execute
					if ddl.is_ok then
						table_exists := True
					else
						print ("could not create table BOOK : " + ddl.diagnostic_message + "%N")
					end
				else
					print ("could not create table BORROWER : "+ ddl.diagnostic_message + "%N")
				end
			else
				print ("could not create table COPY : " + ddl.diagnostic_message + "%N")
			end
		end




	pom : PO_MANAGER do Result := persistence_manager end

	store : detachable ECLI_DATASTORE

end
