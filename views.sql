--1. View--average rating of each trainer
CREATE VIEW AverageTrainerRating AS
    SELECT 
    t.TrainerID,
    t.TrainerName,
    COALESCE(AVG(tr.Rating), 0) AS AverageRating
    FROM Trainers t
    LEFT JOIN TrainerReviews tr ON t.TrainerID = tr.TrainerID
    GROUP BY t.TrainerID, t.TrainerName
    ORDER BY AverageRating DESC;
--2. View--how many transactions used a given promotional code
CREATE VIEW PromoCodeTransactions AS
    SELECT 
    p.DiscountCode,
    COUNT(pay.PaymentID) AS NumberOfTransactions
    FROM 
    Payments pay
    JOIN 
    PromotionCodes p ON pay.DiscountCode = p.DiscountCode
    GROUP BY 
    p.DiscountCode;
