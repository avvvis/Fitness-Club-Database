CREATE NONCLUSTERED INDEX IX_Invoices_Member_Status
ON Invoices (MemberID, Status);   

CREATE NONCLUSTERED INDEX IX_Trainers_Specialization
ON Trainers (Specialization);

CREATE NONCLUSTERED INDEX IX_ClassSchedules_ClubDayTime
ON ClassSchedules (FitnessClubID, Day, StartTime);

CREATE NONCLUSTERED INDEX IX_Members_JoinDate
ON Members (JoinDate);
