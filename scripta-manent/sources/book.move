module account::book {
    use std::string::String;
    use std::vector::Self;
    use std::signer;

    // Error codes
    const EBook_not_found: u64 = 1;
    const EAuthor_not_found: u64 = 2;
    const EChapter_not_found: u64 = 3;
    const EPage_not_found: u64 = 4;
    const EGeneral_not_found: u64 = 5;

    const EAuthor_already_exists: u64 = 6;
    const EAlias_already_exists: u64 = 7;
    const EBook_already_exists: u64 = 8;
    const EBookCollection_not_found: u64 = 9;
    const EGeneral_already_exists: u64 = 10;

    const ENo_changes_made: u64 = 11;
    const ENot_authorized: u64 = 12;


    // Structs
    struct Author has key, copy, drop, store {
        last_name: String,
        first_name: String,
        alias: String,
    }

    struct Page has key, copy, drop, store {
        content: String,
    }

    struct Chapter has key, copy, drop, store {
        title: String,
        pages: vector<Page>,
    }

    struct Book has key, drop, store {
        title: String,
        author: Author,
        chapters: vector<Chapter>,
    }

    struct BookCollection has key {
        books: vector<Book>,
    }


    // View Functions
    #[view]
    public fun get_author(addr: address): (String, String, String) acquires Author {
        let author = borrow_global<Author>(addr);
        (author.first_name, author.last_name, author.alias)
    }

    #[view]
    public fun get_book_title(addr: address): String acquires Book {
        borrow_global<Book>(addr).title
    }

    //Function to specify which chapter you want to access
    #[view]
    public fun get_book_chapter(addr: address, chapter_index: u64): String acquires Book {
        let book = borrow_global<Book>(addr);
        let chapter = vector::borrow(&book.chapters, chapter_index);
        chapter.title
    }

    //Function to specify which page you want to access
    #[view]
    public fun get_book_page(addr: address, chapter_index: u64, page_index: u64): String acquires Book {
        let book = borrow_global<Book>(addr);
        let chapter = vector::borrow(&book.chapters, chapter_index);
        let page = vector::borrow(&chapter.pages, page_index);
        page.content
    }



    // Functions for Author
    public entry fun register_author(account: &signer) acquires Author {
        let signer_address = signer::address_of(account);
        if (exists<Author>(signer_address)) {
            abort EAuthor_already_exists
        };
        // Create a new Author resource
        let author = Author {
            last_name: String,
            first_name: String,
            alias: String,
        };
        // Store the Author resource under the signer's account
        move_to(account, author);
    }

    public entry fun update_author(account: &signer, last_name: String, first_name: String, alias: String) acquires Author {
        let signer_address = signer::address_of(account);
        if (!exists<Author>(signer_address)) {
            abort EAuthor_not_found
        };

        let author = borrow_global_mut<Author>(signer_address);
        if (author.alias == alias) {
            abort EAlias_already_exists
        };
        author.last_name = last_name;
        author.first_name = first_name;
        author.alias = alias;
    }

    public entry fun delete_author(account: &signer) acquires Author {
        let signer_address = signer::address_of(account);
        if (!exists<Author>(signer_address)) {
            abort EAuthor_not_found
        };
        move_from<Author>(signer_address);
    }



    // Functions for Book
    public entry fun new_book(account: &signer, title: String) acquires BookCollection {
        let signer_address = signer::address_of(account);

        // Ensure the author has a BookCollection resource
        if (!exists<BookCollection>(signer_address)) {
            // Initialize an empty BookCollection for the author if it doesn't exist
            let book_collection = BookCollection { books: vector::empty() };
            move_to(account, book_collection)
        };

        let book_collection = borrow_global_mut<BookCollection>(signer_address);

        // Check if a book with the same name already exists in the author's collection
        let books = &mut book_collection.books;
        let index = 0u64;
        let len = vector::length(books);
        loop {
            if (index >= len) { break };
            let existing_book = vector::borrow(books, index);
            if (existing_book.title == title) {
                abort EBook_already_exists;
            };
            index = index + 1;
        };

        // If no book with the same name exists, create and add the new book
        let new_book = Book {
            title: title,
            author: Author {
                last_name: String::empty(),
                first_name: String::empty(),
                alias: String::empty(),
            },
            chapters: vector::empty(),
        };
        vector::push_back(books, new_book);
    }


    public entry fun update_book(account: &signer, old_title: String, new_title: String) acquires BookCollection {
        let signer_address = signer::address_of(account);

        // Check if the BookCollection exists
        assert!(exists<BookCollection>(signer_address), EBookCollection_not_found);

        // Borrow the BookCollection resource
        let book_collection_ref = borrow_global_mut<BookCollection>(signer_address);

        // Find the book with the old_title and update its title to new_title
        let books =  &mut book_collection_ref.books;
        let len = vector::length(books);
        let found = false;

        while (index < len) {
            if (book.title == old_title) {
                // Check if the new title is the same as the old title
                if (book.title == new_title) {
                    abort ENo_changes_made;
                };
                book.title = new_title;
                found = true;
                break
            };
            index = index + 1;
        };
        
        // If the book with the old_title was not found, abort the transaction
        if (!found) {
            abort EBook_not_found;
        }
    }
    

    public entry fun delete_book(account: &signer, title: String) acquires BookCollection {
        let signer_address = signer::address_of(account);

        // Check if the BookCollection exists
        assert!(exists<BookCollection>(signer_address), EBookCollection_not_found);

        // Borrow the BookCollection resource
        let book_collection_ref = borrow_global_mut<BookCollection>(signer_address);

        // Find the index of the book with the given title
        let index_to_remove = 0u64;
        let found = false;
        let len = vector::length(&book_collection_ref.books);
        while (index_to_remove < len) {
            if (vector::borrow(&book_collection_ref.books, index_to_remove).title == title) {
                found = true;
                break
            };
            index_to_remove = index_to_remove + 1;
        };

        // If the book is found, remove it from the collection
        if (found) {
            vector::remove(&mut book_collection_ref.books, index_to_remove);
        } else {
            abort EBook_not_found;
        }
    }


    
    // Functions for Chapter
    public entry fun new_book_chapter(account: &signer, book_collection_address: address, book_index: u64, title: String) acquires BookCollection {
        let signer_address = signer::address_of(account);
        assert!(signer_address == book_collection_address, ENot_authorized);
        assert!(exists<BookCollection>(book_collection_address), EBookCollection_not_found);

        let book_collection = borrow_global_mut<BookCollection>(book_collection_address);
        assert!(vector::length(&book_collection.books) > book_index, EBook_not_found);

        let book = vector::borrow_mut(&mut book_collection.books, book_index);
        let new_chapter = Chapter {
            title: title,
            pages: vector::empty(),
        };
        vector::push_back(&mut book.chapters, new_chapter);
      }


    public entry fun update_book_chapter(account: &signer, book_collection_address: address, book_index: u64, chapter_index: u64, new_title: String) acquires BookCollection {
        let signer_address = signer::address_of(account);
        assert!(signer_address == book_collection_address, ENot_authorized);
        assert!(exists<BookCollection>(book_collection_address), EBookCollection_not_found);

        let book_collection = borrow_global_mut<BookCollection>(book_collection_address);
        assert!(vector::length(&book_collection.books) > book_index, EBook_not_found);

        let book = vector::borrow_mut(&mut book_collection.books, book_index);
        assert!(vector::length(&book.chapters) > chapter_index, EChapter_not_found);

        let chapter = vector::borrow_mut(&mut book.chapters, chapter_index);
        if (chapter.title == new_title) {
            abort ENo_changes_made
        };
        chapter.title = new_title;
    }

    public entry fun delete_book_chapter(account: &signer, book_collection_address: address, book_index: u64, chapter_index: u64) acquires BookCollection {
        let signer_address = signer::address_of(account);
        assert!(signer_address == book_collection_address,  ENot_authorized);
        assert!(exists<BookCollection>(book_collection_address), EBookCollection_not_found);

        let book_collection = borrow_global_mut<BookCollection>(book_collection_address);
        assert!(vector::length(&book_collection.books) > book_index, EBook_not_found);

        let book = vector::borrow_mut(&mut book_collection.books, book_index);
        assert!(vector::length(&book.chapters) > chapter_index, EChapter_not_found);

        vector::remove(&mut book.chapters, chapter_index);
    }



    // Functions for Page
    public entry fun new_book_page(account: &signer, book_collection_address: address, book_index: u64, chapter_index: u64, page_index: u64, content: String) acquires BookCollection {
        let signer_address = signer::address_of(account);
        assert!(signer_address == book_collection_address, ENot_authorized);
        assert!(exists<BookCollection>(book_collection_address), EBookCollection_not_found);

        let book_collection = borrow_global_mut<BookCollection>(book_collection_address);
        assert!(vector::length(&book_collection.books) > book_index, EBook_not_found);

        let book = vector::borrow_mut(&mut book_collection.books, book_index);
        assert!(vector::length(&book.chapters) > chapter_index, EChapter_not_found);

        let chapter = vector::borrow_mut(&mut book.chapters, chapter_index);
        // Check if the page_index is valid before inserting a new page
        assert!(vector::length(&chapter.pages) >= page_index, EPage_not_found);

        let new_page = Page {
            content: content,
        };
        // Insert the new page at the specified index
        vector::insert(&mut chapter.pages, page_index, new_page);
    }

    public entry fun update_book_page(account: &signer, book_collection_address: address, book_index: u64, chapter_index: u64, page_index: u64, new_content: String) acquires BookCollection {
        let signer_address = signer::address_of(account);
        assert!(signer_address == book_collection_address, ENot_authorized);
        assert!(exists<BookCollection>(book_collection_address), EBookCollection_not_found);

        let book_collection = borrow_global_mut<BookCollection>(book_collection_address);
        assert!(vector::length(&book_collection.books) > book_index, EBook_not_found);

        let book = vector::borrow_mut(&mut book_collection.books, book_index);
        assert!(vector::length(&book.chapters) > chapter_index, EChapter_not_found);

        let chapter = vector::borrow_mut(&mut book.chapters, chapter_index);
        assert!(vector::length(&chapter.pages) > page_index, EPage_not_found);

        let page = vector::borrow_mut(&mut chapter.pages, page_index);
        if (page.content == new_content) {
            abort ENo_changes_made
        };
        page.content = new_content;
    }

    public entry fun delete_book_page(account: &signer, book_collection_address: address, book_index: u64, chapter_index: u64, page_index: u64) acquires BookCollection {
        let signer_address = signer::address_of(account);
        assert!(signer_address == book_collection_address, ENot_authorized);
        assert!(exists<BookCollection>(book_collection_address), EBookCollection_not_found);

        let book_collection = borrow_global_mut<BookCollection>(book_collection_address);
        assert!(vector::length(&book_collection.books) > book_index, EBook_not_found);

        let book = vector::borrow_mut(&mut book_collection.books, book_index);
        assert!(vector::length(&book.chapters) > chapter_index, EChapter_not_found);

        let chapter = vector::borrow_mut(&mut book.chapters, chapter_index);
        assert!(vector::length(&chapter.pages) > page_index, EPage_not_found);

        vector::remove(&mut chapter.pages, page_index);
    }
}