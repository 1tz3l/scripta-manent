module account::book {
    use std::string::String;
    use std::signer;

    // Error codes
    const EBook_not_found: u64 = 1;
    const EAuthor_not_found: u64 = 2;
    const EChapter_not_found: u64 = 3;
    const EPage_not_found: u64 = 4;
    const EGeneral_not_found: u64 = 5;

    const EAlias_already_exists: u64 = 6;
    const EAlready_exists: u64 = 7;

    const ENo_changes_made: u64 = 8;
    const ENot_authorized: u64 = 9;

    // Structs
    struct Author has copy, drop, store {
        last_name: String,
        first_name: String,
        alias: String,
    }

    struct Page has copy, drop, store {
        content: String,
    }

    struct Chapter has copy, drop, store {
        title: String,
        pages: vector<Page>,
    }

    struct Book has key, store {
        title: String,
        author: Author,
        chapters: <Chapter>,
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
        let chapter = &book.chapters[chapter_index as usize];
        chapter.title
    }

    //Function to specify which page you want to access
    #[view]
    public fun get_book_page(addr: address, chapter_index: u64, page_index: u64): String acquires Book {
        let book = borrow_global<Book>(addr);
        let chapter = &book.chapters[chapter_index as usize];
        let page = &chapter.pages[page_index as usize];
        page.content
    }

    // Public Entry Functions
    public entry fun register_author(account: &signer) acquires Author {
    }

    public entry fun new_book(account: &signer) acquires Book {
    }

    public entry fun new_chapter(account: &signer, title: String) acquires Chapter {
    }

    public entry fun new_page(account: &signer, content: String) acquires Page {
    }

    public entry fun get_book(account: &signer, title: String) acquires Book {

    }

    public entry fun get_book_chapters(account: &signer, title: String) acquires Book {

    }

    public entry fun get_book_pages(account: &signer, title: String, chapter_index: u64) acquires Book {

    }
    
    public entry fun update_author(account: &signer, last_name: String, first_name: String, alias: String) acquires Author {
        let signer_address = signer::address_of(account);
        if (!exists<Author>(signer_address)) {
            abort EAuthor_not_found;
        }

        let author = borrow_global_mut<Author>(signer_address);
        // Check if the alias is already taken by another author
        if (author.alias == alias) {
            abort EAlias_already_exists;
        }

        author.last_name = last_name;
        author.first_name = first_name;
        author.alias = alias;
    }

    public entry fun update_book(account: &signer, old_title: String, new_title: String) acquires Book {
        let signer_address = signer::address_of(account);
        if (!exists<Book>(signer_address)) {
            abort EBook_not_found;
        }

        let book = borrow_global_mut<Book>(signer_address);
        if (book.title != old_title) {
            abort EGeneral_not_found;
        }
        if (book.title == new_title) {
            abort ENo_changes_made;
        }
        book.title = new_title;
    }

    public entry fun update_chapter(account: &signer, title: String, chapter_index: u64, new_title: String) {
    }

    public entry fun update_page(account: &signer, title: String, chapter_index: u64, page_index: u64, new_content: String) {
    }

    public entry fun delete_author(account: &signer, ) {
    }

    public entry fun delete_book(account: &signer, title: String) {
    }

    public entry fun delete_chapter(account: &signer, title: String, chapter_index: u64) {
    }

    public entry fun delete_page(account: &signer, title: String, chapter_index: u64, page_index: u64) {
    }
}