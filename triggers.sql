-- 1. Trigger -- Auto-Add Member to Leaderboard After 10 Trainings

CREATE TRIGGER trAddToLeaderboard
ON PersonalTrainings
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Leaderboard (MemberID, TotalTrainings, TotalHours, Rank)
    SELECT i.MemberID, COUNT(p.TrainingID), COUNT(p.TrainingID) * 1.5, NULL
    FROM inserted i
    JOIN PersonalTrainings p ON i.MemberID = p.MemberID
    GROUP BY i.MemberID
    HAVING COUNT(p.TrainingID) >= 10
    AND NOT EXISTS (SELECT 1 FROM Leaderboard l WHERE l.MemberID = i.MemberID);
END;

-- 2. Trigger -- Update Invoice Status to 'Paid' After Full Payment

CREATE TRIGGER trUpdateInvoiceStatus
ON Payments
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Invoices
    SET Status = 'Paid'
    FROM Invoices i
    WHERE EXISTS (
        SELECT 1 FROM Payments p
        WHERE p.InvoiceID = i.InvoiceID
        GROUP BY p.InvoiceID
        HAVING SUM(p.AmountPaid) >= i.TotalAmount
    );
END;

-- 3. Trigger -- Apply Discount Automatically Based on Promo Code

CREATE TRIGGER trApplyDiscount
ON Payments
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Payments (InvoiceID, AmountPaid, DiscountCodeID, MemberID, PaymentDate)
    SELECT i.InvoiceID, 
           i.AmountPaid * (1 - COALESCE(pc.DiscountPercentage, 0) / 100.0), 
           i.DiscountCodeID, 
           i.MemberID, 
           i.PaymentDate
    FROM inserted i
    LEFT JOIN DiscountCodes pc ON i.DiscountCodeID = pc.CodeID AND pc.Status = 'Active';
END;

-- 4. Trigger -- Auto-Deactivate Expired Memberships (sets MembershipID in Members on NULL)

CREATE TRIGGER trDeactivateExpiredMembership
ON membershipactions
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE m
    SET m.MembershipID = NULL
    FROM Members m
    WHERE m.MemberID IN (
        SELECT i.MemberID
        FROM inserted i
        WHERE i.EndDate <= GETDATE()
          AND i.ActionType ='Cancelation'
    );
END;

-- 5. Trigger -- Auto-Remove from Leaderboard When Membership Expires (deletes member from leaderboard)
CREATE TRIGGER trRemoveFromLeaderboard
ON membershipactions
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE l
    FROM Leaderboard l
    WHERE l.MemberID IN (
        SELECT i.MemberID
        FROM inserted i
        WHERE i.EndDate <= GETDATE()
          AND i.ActionType = 'Cancelation'
    );
END;
