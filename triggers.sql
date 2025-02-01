-- 1. Trigger -- Auto-Add Member to Leaderboard After 10 Trainings

CREATE TRIGGER Trigger_AddToLeaderboard
ON PersonalTrainings
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MemberID INT, @training_count INT;
    
    SELECT @MemberID = inserted.MemberID
    FROM inserted;
    
    SELECT @training_count = COUNT(*)
    FROM PersonalTrainings
    WHERE MemberID = @MemberID;
    
    IF @training_count >= 10
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Leaderboard WHERE MemberID = @MemberID)
        BEGIN
            INSERT INTO Leaderboard (MemberID, TotalTrainings, TotalHours, Rank)
            VALUES (@MemberID, @training_count, @training_count * 1.5, NULL);
        END;
    END;
END;

-- 2. Trigger -- Update Invoice Status to 'Paid' After Full Payment

CREATE TRIGGER Trigger_UpdateInvoiceStatus
ON Payments
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @InvoiceID INT, @total_payments MONEY, @total_amount MONEY;
    
    SELECT @InvoiceID = inserted.InvoiceID
    FROM inserted;
    
    SELECT @total_payments = COALESCE(SUM(AmountPaid), 0)
    FROM Payments
    WHERE InvoiceID = @InvoiceID;
    
    SELECT @total_amount = TotalAmount
    FROM Invoices
    WHERE InvoiceID = @InvoiceID;
    
    IF @total_payments >= @total_amount
    BEGIN
        UPDATE Invoices
        SET Status = 'Paid'
        WHERE InvoiceID = @InvoiceID;
    END;
END;

-- 3. Trigger -- Apply Discount Automatically Based on Promo Code

CREATE TRIGGER Trigger_ApplyDiscount
ON Payments
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @DiscountCode VARCHAR(50), @discount_percentage INT, @AmountPaid MONEY;
    
    SELECT @DiscountCode = inserted.DiscountCode, @AmountPaid = inserted.AmountPaid
    FROM inserted;
    
    IF @DiscountCode IS NOT NULL
    BEGIN
        SELECT @discount_percentage = DiscountPercentage
        FROM PromotionCodes
        WHERE DiscountCode = @DiscountCode AND Status = 'Active';
        
        IF @discount_percentage IS NOT NULL
        BEGIN
            SET @AmountPaid = @AmountPaid * (1 - (@discount_percentage / 100.0));
        END;
    END;
    
    INSERT INTO Payments (InvoiceID, AmountPaid, DiscountCode)
    SELECT InvoiceID, @AmountPaid, @DiscountCode FROM inserted;
END;

-- 4. Trigger -- Auto-Deactivate Expired Memberships

CREATE TRIGGER Trigger_DeactivateExpiredMembership
ON Memberships
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Members
    SET MembershipID = NULL
    FROM Members m
    INNER JOIN inserted i ON m.MemberID = i.MemberID
    INNER JOIN Memberships ms ON ms.MembershipID = i.MembershipID
    WHERE ms.EndDate <= GETDATE();
END;

-- 5. Trigger -- Auto-Remove from Leaderboard When Membership Expires

CREATE TRIGGER Trigger_RemoveFromLeaderboard
ON Memberships
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM Leaderboard
    WHERE MemberID IN (
        SELECT MemberID FROM inserted
        WHERE EndDate <= GETDATE()
    );
END;
