--1. Trigger--Auto-Add Member to Leaderboard After 10 Trainings

CREATE OR REPLACE FUNCTION AddToLeaderboard() RETURNS TRIGGER AS $$
DECLARE
    training_count INT;
BEGIN
    SELECT COUNT(*) INTO training_count
    FROM PersonalTrainings
    WHERE MemberID = NEW.MemberID;

    IF training_count >= 10 THEN
        INSERT INTO Leaderboard (MemberID, TotalTrainings, TotalHours, Rank)
        VALUES (NEW.MemberID, training_count, training_count * 1.5, NULL)
        ON CONFLICT (MemberID) DO NOTHING;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trigger_AddToLeaderboard
AFTER INSERT ON PersonalTrainings
FOR EACH ROW
EXECUTE FUNCTION AddToLeaderboard();

--2. Trigger--Update Invoice Status to 'Paid' After Full Payment

CREATE OR REPLACE FUNCTION UpdateInvoiceStatus() RETURNS TRIGGER AS $$
DECLARE
    total_payments MONEY;
BEGIN
    SELECT COALESCE(SUM(AmountPaid), 0) INTO total_payments 
    FROM Payments WHERE InvoiceID = NEW.InvoiceID;

    IF total_payments >= (SELECT TotalAmount FROM Invoices WHERE InvoiceID = NEW.InvoiceID) THEN
        UPDATE Invoices 
        SET Status = 'Paid'
        WHERE InvoiceID = NEW.InvoiceID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trigger_UpdateInvoiceStatus
AFTER INSERT OR UPDATE ON Payments
FOR EACH ROW
EXECUTE FUNCTION UpdateInvoiceStatus();

--3. Trigger--Apply Discount Automatically Based on Promo Code

CREATE OR REPLACE FUNCTION ApplyDiscount() RETURNS TRIGGER AS $$
DECLARE
    discount_percentage INT;
BEGIN
    SELECT DiscountPercentage INTO discount_percentage
    FROM PromotionCodes
    WHERE DiscountCode = NEW.DiscountCode AND Status = 'Active';

    IF discount_percentage IS NOT NULL THEN
        NEW.AmountPaid := NEW.AmountPaid * (1 - (discount_percentage / 100.0));
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trigger_ApplyDiscount
BEFORE INSERT ON Payments
FOR EACH ROW
WHEN (NEW.DiscountCode IS NOT NULL)
EXECUTE FUNCTION ApplyDiscount();

--4. Trigger--Auto-Deactivate Expired Memberships

CREATE OR REPLACE FUNCTION DeactivateExpiredMembership() RETURNS TRIGGER AS $$
BEGIN
    UPDATE Members
    SET MembershipID = NULL
    WHERE MemberID = NEW.MemberID
    AND (SELECT EndDate FROM Memberships WHERE MembershipID = NEW.MembershipID) <= NOW();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trigger_DeactivateExpiredMembership
AFTER UPDATE ON Memberships
FOR EACH ROW
EXECUTE FUNCTION DeactivateExpiredMembership();

--5. Trigger--Auto-Remove from Leaderboard When Membership Expires

CREATE OR REPLACE FUNCTION RemoveFromLeaderboard() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM Leaderboard
    WHERE MemberID = NEW.MemberID;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trigger_RemoveFromLeaderboard
AFTER UPDATE ON Memberships
FOR EACH ROW
WHEN (NEW.EndDate <= NOW())
EXECUTE FUNCTION RemoveFromLeaderboard();


