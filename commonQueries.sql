--SELECT Statment that displays which invoices are yet unpaid
SELECT InvoiceID, MemberID, IssueDate, DueDate, TotalAmount
FROM Invoices
WHERE Status = 'Unpaid';

--SELECT statement that shows which discount codes are still active
SELECT CodeID, DiscountCode, DiscountPercentage
FROM DiscountCodes
WHERE Status = 'Active';


--SELECT statement that shows reviews about Trainers
SELECT 
    r.ReviewID,
    r.Rating,
    r.ReviewDate,
    r.Comment,
    t.TrainerName
FROM Reviews r
JOIN TrainerReviews tr ON r.ReviewID = tr.ReviewID
JOIN Trainers t ON tr.TrainerID = t.TrainerID;

--SELECT statement that displays how many members of each membershipType
SELECT 
    ms.MembershipID, 
    ms.MembershipName, 
    COUNT(*) AS MembershipCount
FROM Members m
JOIN Memberships ms ON m.MembershipID = ms.MembershipID
GROUP BY ms.MembershipID, ms.MembershipName;


--SELECT statement that displays how many canceled memberships occured this month
SELECT COUNT(*) AS CancelledMembershipCount
FROM MembershipActions
WHERE ActionType = 'Cancelation'
  AND MONTH(CancelationDate) = MONTH(GETDATE())
  AND YEAR(CancelationDate) = YEAR(GETDATE());
