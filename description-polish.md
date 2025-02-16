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

## Wyzwalacze

## Diagramy relacji

![image](https://github.com/user-attachments/assets/885aaab1-af87-4dba-9a46-94d74b0ad233)


*Mateusz Jędrkowiak, Karolina Kulas & Aleksander Wiśniewski*

*Uniwersytet Jagiellonski, 2025*
