CREATE PROCEDURE CheckoutBook(
    IN p_book_id INT,
    IN p_borrower_id INT,
    IN p_loan_date DATE
)
BEGIN
    DECLARE available_copy INT;

    -- Check if the book is available
    SELECT available_copies INTO available_copy
    FROM Books
    WHERE book_id = p_book_id;

    IF available_copy > 0 THEN
        -- Decrement available copies
        UPDATE Books
        SET available_copies = available_copies - 1
        WHERE book_id = p_book_id;

        -- Insert loan transaction
        INSERT INTO Loans (book_id, borrower_id, loan_date, return_date, status)
        VALUES (p_book_id, p_borrower_id, p_loan_date, NULL, 'On Loan');

        SELECT 'Book checked out successfully' AS Message;
    ELSE
        SELECT 'Book not available for checkout' AS Message;
    END IF;
END;
CREATE PROCEDURE ReturnBook(
    IN p_loan_id INT,
    IN p_return_date DATE
)
BEGIN
    -- Update loan status and return date
    UPDATE Loans
    SET return_date = p_return_date,
        status = 'Returned'
    WHERE loan_id = p_loan_id;

    -- Increment available copies
    UPDATE Books B
    JOIN Loans L ON B.book_id = L.book_id
    SET B.available_copies = B.available_copies + 1
    WHERE L.loan_id = p_loan_id;

    SELECT 'Book returned successfully' AS Message;
END;
SELECT B.title AS Book_Title, 
       B.author AS Book_Author, 
       Br.name AS Borrower_Name, 
       Br.email AS Borrower_Email, 
       L.loan_date AS Loan_Date, 
       L.return_date AS Return_Date,
       DATEDIFF(NOW(), L.return_date) AS Days_Overdue,
       DATEDIFF(NOW(), L.return_date) * 0.5 AS Overdue_Fine
FROM Loans L
JOIN Books B ON L.book_id = B.book_id
JOIN Borrowers Br ON L.borrower_id = Br.borrower_id
WHERE L.status = 'On Loan' AND L.return_date < NOW();
