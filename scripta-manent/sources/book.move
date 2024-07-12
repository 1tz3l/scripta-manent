module account::book {
    use std::string::String;
    use std::signer;

    const EBook_not_found: u64 = 1;
    const ENo_changes_made: u64 = 2;

    struct Author has copy, drop {
        last_name: String,
        first_name: String,
        alias: String,
    }

    struct Page has copy, drop {
        page: String,
    }

    struct Chapter has copy, drop {
        title: String,
        page1: Page,
        page2: Page,
        page3: Page,
        page4: Page,
        page5: Page,
        page6: Page,
        page7: Page,
        page8: Page,
        page9: Page,
        page10: Page,
    }

    struct Book has key {
        title: String,
        author: Author,
        chapter1: Chapter,
        chapter2: Chapter,
        chapter3: Chapter,
        chapter4: Chapter,
        chapter5: Chapter,
        chapter6: Chapter,
        chapter7: Chapter,
        chapter8: Chapter,
        chapter9: Chapter,
        chapter10: Chapter,
        chapter11: Chapter,
        chapter12: Chapter,
    }


    public entry fun register_author(account: &signer)

    public entry fun new_book(account: &signer) acquires Book {
        let
    }

    public entry fun get_book(account: &signer, title: String) acquires Book {
        let book = 
    }

    public entry fun update_book(account: &signer, title: String, new_title: String) {
        let book = 
    }

    public entry fun delete_book(account: &signer, title: String) {
        let book = 
    }
}