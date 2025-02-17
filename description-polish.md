*Mateusz Jędrkowiak, Karolina Kulas & Aleksander Wiśniewski*

*Uniwersytet Jagiellonski, 2025*
# Baza danych klubu fitness - "MAK fintess" 
<p align="center">
  <img src="LOGO.png" width="100" />
</p>

#### **Cele:**  
1. **Efektywne zarządzanie danymi** – baza danych ma na celu przechowywanie, organizowanie i przetwarzanie informacji związanych z działalnością klubu fitness, w tym faktur, płatności, członkostw, rezerwacji zajęć i opinii użytkowników.  
2. **Automatyzacja procesów** – system umożliwia automatyczne rejestrowanie transakcji, monitorowanie obecności na zajęciach oraz zarządzanie harmonogramami treningów.  
3. **Personalizacja usług** – dzięki przechowywaniu szczegółowych danych o użytkownikach, ich członkostwach i aktywności, można dostosowywać ofertę klubu do indywidualnych potrzeb klientów.  
4. **Optymalizacja operacyjna** – baza wspiera zarządzanie personelem, sprzętem oraz zamówieniami, co usprawnia codzienne funkcjonowanie klubu fitness.  
5. **Analiza i raportowanie** – umożliwia gromadzenie danych o frekwencji, dochodach, skuteczności trenerów oraz poziomie satysfakcji klientów, co pozwala na podejmowanie lepszych decyzji biznesowych.  

#### **Możliwości:**  
1. **Elastyczne zarządzanie członkostwami** – obsługa różnych typów członkostw (indywidualnych i firmowych) z możliwością przypisywania różnych uprawnień i korzyści.  
2. **Śledzenie płatności i faktur** – rejestrowanie płatności, generowanie faktur oraz zarządzanie rabatami i kodami zniżkowymi.  
3. **Rezerwacja zajęć i treningów personalnych** – użytkownicy mogą zapisywać się na zajęcia, a system może zarządzać listami oczekujących.  
4. **Oceny i recenzje** – użytkownicy mogą wystawiać opinie o trenerach i zajęciach, co pozwala na ocenę jakości usług.  
5. **Zarządzanie zasobami klubu** – system przechowuje dane o sprzęcie, pracownikach oraz obiektach, co pozwala na lepszą organizację pracy klubu.  
6. **Rywalizacja i motywacja użytkowników** – ranking członków (Leaderboard) umożliwia prowadzenie konkursów i zwiększanie zaangażowania klientów.  
7. **Obsługa sprzedaży i zamówień** – rejestrowanie sprzedaży produktów (merch), realizacja zamówień i zarządzanie stanami magazynowymi.  

#### **Ograniczenia:**  
1. **Złożoność systemu** – duża liczba powiązanych tabel wymaga starannego projektowania zapytań oraz optymalizacji wydajności, aby uniknąć opóźnień w przetwarzaniu danych.  
2. **Potrzeba regularnej konserwacji** – konieczne jest monitorowanie integralności danych, optymalizacja indeksów oraz tworzenie kopii zapasowych, aby zapewnić niezawodność systemu.  
3. **Bezpieczeństwo danych** – ze względu na przechowywanie wrażliwych informacji (dane klientów, płatności), wymagane są odpowiednie mechanizmy ochrony, takie jak szyfrowanie i kontrola dostępu.  
4. **Skalowalność** – przy dużej liczbie użytkowników może być konieczna optymalizacja struktury bazy lub migracja do bardziej wydajnego systemu, aby uniknąć problemów z wydajnością.  
5. **Integracja z innymi systemami** – możliwość wymiany danych z systemami płatności, księgowości czy aplikacjami mobilnymi może wymagać dodatkowych rozwiązań technicznych i interfejsów API.  


## Schemat pielęgnacji bazy danych
Aby zapewnić stabilne działanie systemu i zminimalizować ryzyko utraty danych, warto wdrożyć skuteczne procedury utrzymaniowe:  

- **Codzienne kopie zapasowe** – każdej nocy, w czasie przestoju restauracji, należy wykonywać różnicowe backupy, aby zapewnić aktualność danych.  
- **Pełne kopie zapasowe** – raz w tygodniu, w godzinach nocnych, zaleca się tworzenie pełnych kopii zapasowych, co umożliwi szybkie odtworzenie systemu w razie awarii.  
- **Monitorowanie integralności danych** – regularna weryfikacja spójności i poprawności relacji między tabelami pozwoli uniknąć błędów logicznych i nieprawidłowych powiązań.  
- **Optymalizacja wydajności** – okresowe odświeżanie indeksów i statystyk bazy danych w celu przyspieszenia operacji i zwiększenia efektywności zapytań.  
- **Polityka retencji danych** – ustalenie jasnych zasad dotyczących archiwizacji i usuwania przestarzałych danych transakcyjnych, aby zapobiec niekontrolowanemu wzrostowi bazy danych.  
- **Dodatkowe zabezpieczenia** – wdrożenie mechanizmów szyfrowania i kontroli dostępu, aby chronić wrażliwe informacje przed nieautoryzowanym dostępem.  
- **Testy odtwarzania danych** – regularne przeprowadzanie próbnego przywracania systemu z backupów, aby upewnić się, że proces działa sprawnie i pozwala na szybkie odzyskanie danych w razie awarii.

## Lista tabel
[kod](https://github.com/avvvis/Fitness-Club-Database/blob/main/tables.sql)
1. **Invoices** – Przechowuje dane o fakturach, takie jak numer faktury, data wystawienia, kwota, status płatności i powiązany członek lub firma.  
2. **Payments** – Zawiera informacje o dokonanych płatnościach, w tym metodę płatności, kwotę, datę oraz powiązaną fakturę.  
3. **Members** – Przechowuje dane o członkach klubu, takie jak imię, nazwisko, e-mail, numer telefonu, adres i status członkostwa.  
4. **Memberships** – Rejestruje informacje o członkostwach, w tym typ, czas trwania, cenę i powiązane uprawnienia.  
5. **IndvidualMemberships** – Zawiera szczegółowe informacje o członkostwach indywidualnych, przypisanych do konkretnego członka.  
6. **CompanyMemberships** – Przechowuje dane o członkostwach firmowych, które mogą obejmować wielu pracowników jednej firmy.  
7. **MembershipActions** – Rejestruje działania związane z członkostwem, np. przedłużenia, anulowania czy zmiany pakietu.  
8. **Leaderboard** – Przechowuje dane o wynikach i aktywności użytkowników w klubie, np. liczba odwiedzin, treningi, osiągnięcia.  
9. **Trainers** – Zawiera informacje o trenerach, ich specjalizacjach, doświadczeniu, certyfikatach oraz dostępności.  
10. **Reviews** – Ogólna tabela przechowująca recenzje różnych usług i trenerów w klubie.  
11. **TrainerReviews** – Przechowuje oceny i opinie użytkowników na temat konkretnych trenerów.  
12. **ClassesReviews** – Zawiera recenzje dotyczące zajęć grupowych, ich jakości, instruktora oraz poziomu trudności.  
13. **Classes** – Opisuje zajęcia fitness, ich typ, poziom trudności, maksymalną liczbę uczestników i powiązanego instruktora.  
14. **ClassTrainers** – Powiązanie trenerów z zajęciami, pozwala na przypisanie kilku trenerów do jednej klasy.  
15. **ClassEnrollments** – Przechowuje dane o zapisach na zajęcia, w tym użytkownika, zajęcia i datę zapisania.  
16. **ClassSchedules** – Zawiera harmonogramy zajęć, godziny rozpoczęcia, daty oraz dostępność miejsc.  
17. **WaitLists** – Przechowuje listy oczekujących na zajęcia, jeśli nie ma już dostępnych miejsc.  
18. **PersonalTrainings** – Rejestruje indywidualne treningi, ich daty, czas trwania, trenera oraz uczestnika.  
19. **Equipment** – Przechowuje informacje o sprzęcie dostępnym w klubie, jego stanie, dostępności i terminach konserwacji.  
20. **FitnessClubs** – Zawiera dane o różnych lokalizacjach siłowni, ich adresach, godzinach otwarcia i oferowanych usługach.  
21. **Employees** – Rejestruje pracowników klubu, ich stanowiska, grafik pracy oraz wynagrodzenia.  
22. **Merch** – Przechowuje informacje o produktach sprzedawanych w klubie, np. odzież sportowa, suplementy.  
23. **MerchOrders** – Zawiera dane o zamówieniach na produkty, w tym klienta, zamówione przedmioty, datę i status realizacji.  
24. **DiscountCodes** – Przechowuje kody rabatowe, ich wartości, warunki użycia oraz daty ważności.  
25. **Attendance** – Rejestruje obecność członków w klubie, w tym datę, godzinę wejścia i wyjścia oraz powiązane członkostwo.  

## Widoki
[kod](https://github.com/avvvis/Fitness-Club-Database/blob/main/views.sql)

1. **vwAverageTrainerRating** - **Średnia ocena trenera**
   - Ten widok oblicza średnią ocenę dla każdego trenera na podstawie ocen w recenzjach. W przypadku braku recenzji dla trenera, zwróci wartość 0 (dzięki funkcji `COALESCE`). Widok zawiera identyfikator trenera, jego nazwisko oraz średnią ocenę.

2. **vwPromoCodeTransactions** - **Transakcje z użyciem kodu promocyjnego**
   - Widok ten pokazuje, ile transakcji skorzystało z danego kodu rabatowego. Zlicza liczbę transakcji, które wykorzystały określony kod rabatowy, łącząc tabele płatności z kodami rabatowymi.

3. **vwMemberAttendance** - **Obecności członków**
   - Widok zawiera dane o obecnościach członków na zajęciach, łącząc tabele `Attendance`, `Members` i `Classes`. Zawiera identyfikator obecności, identyfikator członka, typ członkostwa, identyfikator zajęć, nazwę zajęć, datę obecności oraz status obecności (np. obecny, nieobecny).

4. **vwEnrollmentExtremes** - **Zajęcia z największą i najmniejszą liczbą zapisów**
   - Widok ten identyfikuje zajęcia z największą oraz najmniejszą liczbą zapisanych uczestników. Wykorzystuje CTE (Common Table Expressions) do zliczenia liczby zapisów na każde zajęcia oraz do znalezienia maksymalnej i minimalnej liczby zapisów. Na końcu filtruje wyniki, aby pokazać tylko te zajęcia, które mają największą lub najmniejszą liczbę zapisanych uczestników.

5. **vwAverageClassRating** - **Średnia ocena zajęć**
   - Widok oblicza średnią ocenę dla każdego typu zajęć. Łączy tabele `Classes`, `ClassesReviews` i `Reviews`, aby obliczyć średnią ocenę dla każdego kursu, w tym także uwzględnia poziom trudności kursu.

6. **vwTop3InEachGroup - Top 3 członków w każdej grupie**  
  - Ten widok pokazuje trzech najlepszych członków w tabeli wyników dla każdej grupy zajęciowej. Wybiera tylko członków z pozycją w rankingu równą lub wyższą niż 3, a następnie grupuje wynik według grup zajęciowych.  

7. **vwCountMembershipType - Liczba każdego typu członkostwa**  
  - Ten widok zlicza liczbę zarejestrowanych członkostw dla każdego typu członkostwa.  

8. **vwActiveMembersEnrolled - Liczba aktywnych członków zapisanych na każde zaplanowane zajęcia**  
  - Ten widok pokazuje, ilu aktywnych członków zapisało się na zaplanowane zajęcia. Łączy tabele `ClassSchedules` i `ClassEnrollments`, aby policzyć liczbę zapisanych członków dla każdego kursu. Dodatkowo wynik jest filtrowany, aby uwzględnić tylko aktywnych członków.  

9. **vwTotalIncomePerMonth - Całkowity przychód w każdym miesiącu**  
  - Ten widok pokazuje, ile klub zarobił na członkostwach w każdym miesiącu. Grupuje płatności według miesiąca i oblicza ich sumę dla każdego miesiąca.  

10. **vwLocationsSortedByNeededMaintanance - Ilosc potrzebnych konserwacji w kazdej lokalizacji**  
  - Ten widok pokazuje lokalizacje klubów oraz ilość sprzętu wymagającego konserwacji w każdej z nich.
 

## Wyzwalacze
[kod](https://github.com/avvvis/Fitness-Club-Database/blob/main/triggers.sql)

1. **trAddToLeaderboard** - **Automatyczne dodanie członka do tabeli liderów po 10 treningach**
   - Ten wyzwalacz automatycznie dodaje członka do tabeli liderów, gdy po zapisaniu treningu osobistego (w tabeli `PersonalTrainings`) członek osiągnie 10 zakończonych treningów. Sprawdza, czy członek już znajduje się w tabeli liderów, a jeśli nie, dodaje go z liczbą ukończonych treningów oraz obliczoną liczbą godzin (liczba treningów pomnożona przez 1.5).

2. **trUpdateInvoiceStatus** - **Aktualizacja statusu faktury na 'Opłacona' po pełnej płatności**
   - Wyzwalacz ten aktualizuje status faktury na "Opłacona", gdy po wprowadzeniu lub zaktualizowaniu płatności (tabela `Payments`) suma zapłaconej kwoty osiągnie całkowitą kwotę faktury. Sprawdza, czy suma wszystkich płatności za daną fakturę jest większa lub równa pełnej kwocie faktury, a następnie zmienia jej status na "Opłacona".

3. **trApplyDiscount** - **Automatyczne zastosowanie rabatu na podstawie kodu promocyjnego**
   - Ten wyzwalacz modyfikuje płatność wstawioną do tabeli `Payments` (zamiast standardowego wstawiania), aby automatycznie zastosować rabat, jeśli został użyty aktywny kod promocyjny. Oblicza nową kwotę zapłaty, uwzględniając procent rabatu związanego z kodem promocyjnym. Zastosowanie rabatu zależy od tego, czy kod promocyjny jest aktywny.

4. **trDeactivateExpiredMembership** - **Automatyczne dezaktywowanie wygasłych członkostw**
   - Wyzwalacz ten dezaktywuje członkostwo, ustawiając `MembershipID` na NULL w tabeli `Members`, gdy członek zakończy swoje członkostwo (akcja typu "Cancelation") i data zakończenia członkostwa w tabeli `membershipactions` jest wcześniejsza lub równa bieżącej dacie. Oznacza to, że członkostwo wygasło, a członek już nie jest aktywnym użytkownikiem.

5. **trRemoveFromLeaderboard** - **Automatyczne usunięcie z tabeli liderów, gdy członkostwo wygasa**
   - Ten wyzwalacz usuwa członka z tabeli liderów, jeśli jego członkostwo wygasło (akcja typu "Cancelation" w tabeli `membershipactions`). Jeśli data zakończenia członkostwa jest wcześniejsza lub równa bieżącej dacie, członek zostaje usunięty z tabeli `Leaderboard`, co oznacza, że już nie jest częścią systemu rankingu.

## Procedury składowane
[kod](https://github.com/avvvis/Fitness-Club-Database/blob/main/procedures.sql)

1. **UpdateEquipmentMaintenanceDate** - **Procedura aktualizacji daty konserwacji sprzętu**
   - Procedura ta umożliwia aktualizację daty ostatniej konserwacji sprzętu na podstawie przekazanego identyfikatora sprzętu (`@EquipmentID`) oraz nowej daty konserwacji (`@NewMaintenanceDate`). Zaktualizowana zostanie tabela `Equipment`, gdzie wartość w kolumnie `LastMaintenance` zostanie ustawiona na nową datę konserwacji.

2. **AddReview** - **Procedura dodawania recenzji**
   - Procedura ta pozwala na dodanie recenzji, która może dotyczyć trenera lub zajęć (w zależności od wartości parametru `@ReviewType`). Wstawiane są dane do tabeli `Reviews`, a następnie, w zależności od rodzaju recenzji, dodawane są wpisy do tabel `TrainerReviews` (dla recenzji trenera) lub `ClassesReviews` (dla recenzji zajęć). Jeżeli podany typ recenzji jest błędny, procedura wypisuje komunikat o błędzie.

3. **UpdateLeaderboard** - **Procedura aktualizacji tabeli liderów**
   - Procedura ta aktualizuje tabelę liderów na podstawie obecności członka na zajęciach. Jeśli status obecności to "Present" (obecny), sprawdzane jest, czy dany członek i zajęcia znajdują się już w tabeli liderów. Jeśli tak, liczba treningów oraz godziny treningu są aktualizowane. Jeśli nie, członek i zajęcia są dodawane do tabeli liderów. Następnie rankingi w tabeli liderów są aktualizowane na podstawie sumy godzin treningów.

4. **CancelOverDueMembers** - **Procedura anulowania członkostwa dla członków z niezapłaconymi fakturami**
   - Procedura ta anuluje członkostwo członków, którzy mają zaległe płatności (faktury z datą wymagalności wcześniejszą niż dzisiejsza, o statusie "Unpaid" lub "Pending"). Dodatkowo, akcja anulowania członkostwa jest rejestrowana w tabeli `MembershipActions`, gdzie zapisane są szczegóły anulowania, takie jak data anulowania i powód.

5. **usp_UpdateWaitlistForClass** - **Procedura aktualizacji listy oczekujących na zajęcia**
   - Procedura ta sprawdza dostępne miejsca na zajęciach (w tabeli `ClassEnrollments`), porównując liczbę zapisanych osób z maksymalną pojemnością klasy. Jeśli są dostępne wolne miejsca, aktualizuje status osób z listy oczekujących (`Waitlists`), które mogą zostać przeniesione do listy potwierdzonych uczestników. Dodatkowo, numer kolejki na liście oczekujących jest aktualizowany, aby zachować odpowiednią kolejność.

## Diagramy relacji

![image](https://github.com/user-attachments/assets/885aaab1-af87-4dba-9a46-94d74b0ad233)
![image](https://github.com/avvvis/Fitness-Club-Database/blob/main/ER%20diagram.png)

*Mateusz Jędrkowiak, Karolina Kulas & Aleksander Wiśniewski*

*Uniwersytet Jagiellonski, 2025*
