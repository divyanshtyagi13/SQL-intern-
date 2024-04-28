CREATE PROCEDURE AddBook(
    IN p_title_name VARCHAR(255),
    IN p_author VARCHAR(255),
    IN p_isbn VARCHAR(20),
    IN p_genre VARCHAR(100),
    IN p_publication_year INT,
    IN p_available_copies INT,
    IN p_location VARCHAR(100)
)
BEGIN
    DECLARE title_id INT;

    -- Insert into Titles table
    INSERT INTO Titles (title_name, isbn, genre, publication_year)
    VALUES (p_title_name, p_isbn, p_genre, p_publication_year);

    -- Get the generated title_id
    SET title_id = LAST_INSERT_ID();

    -- Insert into Books table
    INSERT INTO Books (title_id, author, available_copies)
    VALUES (title_id, p_author, p_available_copies);

    -- Insert into Catalogs table
    INSERT INTO Catalogs (title_id, location)
    VALUES (title_id, p_location);

    SELECT 'Book added successfully' AS Message;
END;
CREATE PROCEDURE SearchBookByTitle(
    IN p_title_name VARCHAR(255)
)
BEGIN
    SELECT B.title_id, T.title_name, B.author, T.isbn, T.genre, T.publication_year, B.available_copies, C.location
    FROM Books B
    INNER JOIN Titles T ON B.title_id = T.title_id
    INNER JOIN Catalogs C ON B.title_id = C.title_id
    WHERE T.title_name LIKE CONCAT('%', p_title_name, '%');
END;
CREATE PROCEDURE ManageInventory(
    IN p_title_id INT,
    IN p_change_amount INT
)
BEGIN
    UPDATE Books
    SET available_copies = available_copies + p_change_amount
    WHERE title_id = p_title_id;

    SELECT 'Inventory updated successfully' AS Message;
END;
