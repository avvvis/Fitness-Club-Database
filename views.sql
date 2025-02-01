-- 1. View -- Average rating of each trainer

CREATE VIEW AverageTrainerRating AS
    SELECT 
        t.TrainerID,
        t.TrainerName,
        COALESCE(AVG(tr.Rating * 1.0), 0) AS AverageRating  
    FROM Trainers t
    LEFT JOIN TrainerReviews tr ON t.TrainerID = tr.TrainerID
    GROUP BY t.TrainerID, t.TrainerName;

-- 2. View -- How many transactions used a given promotional code

CREATE VIEW PromoCodeTransactions AS
    SELECT 
        dc.DiscountCode,
        COUNT(p.PaymentID) AS NumberOfTransactions
    FROM Payments p
    JOIN DiscountCodes dc ON p.DiscountCodeID = dc.CodeID  
    GROUP BY dc.DiscountCode;
