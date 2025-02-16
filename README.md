**Mateusz Jędrkowiak, Karolina Kulas & Aleksander Wiśniewski**

**Jagiellonian University, 2025**  
# Fitness Club Database - "MAK Fitness"  

<p align="center">
  <img src="LOGO.png" width="100" />
</p>

#### **Objectives:**  
1. **Efficient Data Management** – The database aims to store, organize, and process information related to the fitness club's operations, including invoices, payments, memberships, class reservations, and user feedback.  
2. **Automation of Processes** – The system allows for automatic transaction recording, attendance monitoring, and class schedule management.  
3. **Personalization of Services** – By storing detailed data on users, their memberships, and activities, the club's offerings can be tailored to individual client needs.  
4. **Operational Optimization** – The database supports the management of staff, equipment, and orders, improving the daily operations of the fitness club.  
5. **Analysis and Reporting** – It enables the collection of data on attendance, income, trainer performance, and customer satisfaction, aiding in making better business decisions.  

#### **Capabilities:**  
1. **Flexible Membership Management** – Handling different types of memberships (individual and corporate) with the ability to assign various privileges and benefits.  
2. **Payment and Invoice Tracking** – Recording payments, generating invoices, and managing discounts and promo codes.  
3. **Class and Personal Training Reservations** – Users can sign up for classes, and the system can manage waiting lists.  
4. **Ratings and Reviews** – Users can leave feedback on trainers and classes, providing an evaluation of the services.  
5. **Resource Management** – The system stores data about equipment, staff, and facilities, helping to organize the club's operations better.  
6. **User Competition and Motivation** – A leaderboard allows for the organization of contests and boosting client engagement.  
7. **Sales and Order Management** – Recording product sales (e.g., merchandise), processing orders, and managing inventory.  

#### **Limitations:**  
1. **System Complexity** – The large number of related tables requires careful query design and performance optimization to avoid delays in data processing.  
2. **Regular Maintenance Needs** – It's necessary to monitor data integrity, optimize indexes, and create backups to ensure system reliability.  
3. **Data Security** – Due to the storage of sensitive information (e.g., client data, payments), appropriate protection mechanisms, such as encryption and access control, are required.  
4. **Scalability** – With a large number of users, database structure optimization or migration to a more efficient system may be necessary to avoid performance issues.  
5. **Integration with Other Systems** – Data exchange with payment systems, accounting, or mobile apps may require additional technical solutions and API interfaces.  

## Database Maintenance Plan  
To ensure the stable operation of the system and minimize the risk of data loss, effective maintenance procedures should be implemented:  

- **Daily Backups** – Differential backups should be performed every night during the system's downtime to maintain up-to-date data.  
- **Full Backups** – A full backup should be performed weekly during the night to ensure quick system restoration in case of failure.  
- **Data Integrity Monitoring** – Regular checks for consistency and correctness of relationships between tables help prevent logical errors and invalid associations.  
- **Performance Optimization** – Periodic refreshes of indexes and database statistics to speed up operations and improve query efficiency.  
- **Data Retention Policy** – Clear rules for archiving and deleting outdated transaction data should be established to prevent uncontrolled database growth.  
- **Additional Security Measures** – Implementation of encryption and access control mechanisms to protect sensitive information from unauthorized access.  
- **Data Recovery Testing** – Regular practice of data restoration from backups to ensure the process is effective and allows for rapid data recovery in case of failure.

## List of Tables  
[code](https://github.com/avvvis/Fitness-Club-Database/blob/main/tables.sql)
1. **Invoices** – Stores data about invoices, such as invoice number, issue date, amount, payment status, and the associated member or company.  
2. **Payments** – Contains information about completed payments, including payment method, amount, date, and associated invoice.  
3. **Members** – Stores information about club members, such as name, email, phone number, address, and membership status.  
4. **Memberships** – Registers information about memberships, including type, duration, price, and associated privileges.  
5. **IndividualMemberships** – Contains detailed information about individual memberships assigned to specific members.  
6. **CompanyMemberships** – Stores data about corporate memberships, which can cover multiple employees of a company.  
7. **MembershipActions** – Registers actions related to memberships, such as extensions, cancellations, or changes in plans.  
8. **Leaderboard** – Stores data about members' performance and activity in the club, such as the number of visits, training sessions, and achievements.  
9. **Trainers** – Contains information about trainers, their specialties, experience, certifications, and availability.  
10. **Reviews** – A general table storing reviews for various services and trainers in the club.  
11. **TrainerReviews** – Stores ratings and feedback from users about specific trainers.  
12. **ClassesReviews** – Contains reviews about group classes, their quality, instructor, and difficulty level.  
13. **Classes** – Describes fitness classes, their type, difficulty level, maximum number of participants, and associated instructor.  
14. **ClassTrainers** – Links trainers to classes, allowing multiple trainers to be assigned to a single class.  
15. **ClassEnrollments** – Stores data about class enrollments, including user, class, and enrollment date.  
16. **ClassSchedules** – Contains class schedules, start times, dates, and availability of spots.  
17. **WaitLists** – Stores waiting lists for classes if no spots are available.  
18. **PersonalTrainings** – Registers individual training sessions, including dates, duration, trainer, and participant.  
19. **Equipment** – Stores information about equipment available at the club, its condition, availability, and maintenance dates.  
20. **FitnessClubs** – Contains data about different club locations, their addresses, operating hours, and offered services.  
21. **Employees** – Registers club staff, their positions, work schedules, and salaries.  
22. **Merch** – Stores information about products sold at the club, such as sportswear, supplements, etc.  
23. **MerchOrders** – Contains data about product orders, including the customer, ordered items, date, and status of fulfillment.  
24. **DiscountCodes** – Stores information about discount codes, their values, usage conditions, and expiration dates.  
25. **Attendance** – Records member attendance in the club, including date, entry/exit time, and associated membership.

## Views  
[code](https://github.com/avvvis/Fitness-Club-Database/blob/main/views.sql)

1. **vwAverageTrainerRating** – **Average Trainer Rating**  
   - This view calculates the average rating for each trainer based on reviews. If no reviews exist for a trainer, it will return 0 (using the `COALESCE` function). The view contains the trainer's ID, last name, and average rating.

2. **vwPromoCodeTransactions** – **Promo Code Transactions**  
   - This view shows how many transactions used a specific promo code. It counts the number of transactions that used a particular promo code by joining payment and discount code tables.

3. **vwMemberAttendance** – **Member Attendance**  
   - This view contains data on member attendance at classes by joining the `Attendance`, `Members`, and `Classes` tables. It includes the attendance ID, member ID, membership type, class ID, class name, attendance date, and status (e.g., present, absent).

4. **vwEnrollmentExtremes** – **Classes with Most and Fewest Enrollments**  
   - This view identifies classes with the highest and lowest number of enrolled participants. It uses Common Table Expressions (CTE) to count enrollments for each class and then finds the maximum and minimum enrollment numbers.

5. **vwAverageClassRating** – **Average Class Rating**  
   - This view calculates the average rating for each type of class. It joins the `Classes`, `ClassesReviews`, and `Reviews` tables to compute the average class rating, including the difficulty level of each course.
     
6. **vwTop3InEachGroup** - **Top 3 Members in Each Group**
   - This view shows top 3 members in leaderboard for each class group. It selects only members with rank higher or equal to 3 and then groups the result by class groups. 

7. **vwCountMembershipType** - **Number of Each Membership Type**
  - This view counts the number of each membership type registered.

8. **vwActiveMembersEnrolled** - **Number of Active Members Enrolled in Each Scheduled Class**
   - This view shows how many active members have enrolled for the scheduled classes. It joins `ClassSchedules` and  `ClassEnrollments` tabels to count the number of members enrolled in each class. Additionally, the result is sorted to show only Active members.

9. **vwTotalIncomePerMonth** - **Total Income Each Month**
  - This view shows how much the club has earned from memberships each month. It goups payments by payment month to calculate the sum each month.

10. **vwLocationsSortedByNeededMaintanance** - **Locations In Order Of How Much Equipment Needes Maintanance**
  - This view shows clubs location and how much equipment needs maintanace at each location. Additionaly, the result is soreted to show locations that need maintanance the most first.
## Triggers  
[code](https://github.com/avvvis/Fitness-Club-Database/blob/main/triggers.sql)

1. **trAddToLeaderboard** – **Automatically Add Member to Leaderboard after 10 Trainings**  
   - This trigger automatically adds a member to the leaderboard when they complete 10 personal training sessions. It checks if the member is already in the leaderboard; if not, it adds them with the completed training count and calculated hours (number of trainings multiplied by 1.5).

2. **trUpdateInvoiceStatus** – **Update Invoice Status to 'Paid' after Full Payment**  
   - This trigger updates the invoice status to "Paid" when the sum of payments for a given invoice reaches or exceeds its total amount. It checks if the total of payments equals or exceeds the full invoice amount and changes the invoice status.

3. **trApplyDiscount** – **Automatically Apply Discount Based on Promo Code**  
   - This trigger modifies the payment in the `Payments` table (instead of standard insert) to automatically apply a discount if an active promo code is used. It calculates the new payment amount, taking into account the discount percentage related to the promo code.

4. **trDeactivateExpiredMembership** – **Automatically Deactivate Expired Memberships**  
   - This trigger deactivates memberships by setting `MembershipID` to NULL in the `Members` table when a member cancels their membership, and the cancellation date is on or before the current date.

5. **trRemoveFromLeaderboard** – **Automatically Remove from Leaderboard when Membership Expires**  
   - This trigger removes a member from the leaderboard if their membership expires. It checks if the cancellation date is on or before the current date and removes the member from the leaderboard.

## Stored Procedures  
[code](https://github.com/avvvis/Fitness-Club-Database/blob/main/procedures.sql)

1. **UpdateEquipmentMaintenanceDate** – **Update Equipment Maintenance Date**  
   - This procedure allows updating the equipment's last maintenance date based on the provided `@EquipmentID` and new maintenance date (`@NewMaintenanceDate`). It updates the `Equipment` table with the new maintenance date.

2. **AddReview** – **Add a Review**  
   - This procedure allows adding a review for a trainer or class (depending on the `@ReviewType` parameter). It inserts data into the `Reviews` table and then, depending on the review type, adds entries to either `TrainerReviews` or `ClassesReviews` tables.

3. **UpdateLeaderboard** – **Update Leaderboard Table**  
   - This procedure updates the leaderboard based on a member’s attendance in classes. If the attendance status is "Present," it checks if the member and class already exist in the leaderboard; if so, it updates the number of trainings and training hours. Otherwise, the member and class are added to the leaderboard, and the rankings are updated.

4. **CancelOverDueMembers** – **Cancel Membership for Members with Unpaid Invoices**  
   - This procedure cancels the membership of members who have overdue invoices (invoices with a due date earlier than today and a status of "Unpaid" or "Pending"). The cancellation action is recorded in the `MembershipActions` table with details like cancellation date and reason.

5. **usp_UpdateWaitlistForClass** – **Update Waitlist for Class**  
   - This procedure checks available spots for classes by comparing the number of enrolled users with the class capacity. If there are available spots, it updates the waitlist status, moving users from the waiting list to confirmed participants.

## Entity Relationship Diagrams  

![image](https://github.com/user-attachments/assets/885aaab1-af87-4dba-9a46-94d74b0ad233)  
![image](https://github.com/avvvis/Fitness-Club-Database/blob/main/ER%20diagram.png)

**Mateusz Jędrkowiak, Karolina Kulas & Aleksander Wiśniewski**

**Jagiellonian University, 2025**
