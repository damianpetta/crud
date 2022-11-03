Witam, zgodnie z poleceniem zamiast frontendu zrobiłem aplikacje we flutterze.

# JAK WŁĄCZYĆ:
- uruchamiamy plik main.go 
- Folder flutter_app_gui zawiera cały projekt aplikacji napisanej we flutterze. 
  Ten projekt należy również uruchomić. 
  Wszystkie ewentualne testy aplikacji przeprowadzałem na emulatorze.
# JAK UŻYWAĆ:
  -  <LOGOWANIE,WYLOGOWYWANIE>
     - W celu wyświetlania, dodawnia, edytowania i usuwania studentów trzeba utworzyć nowego użytkownika z rolą "admin". 
       (Jednorazowo utworzyć przy pomocy przyciusku register, potem tylko logować się podanymi przy rejestracji danymi)
       Jeśli chcemy tylko wyświetlać i edytować trzeba trzeba utworzyć nowego użytkownika z rolą "developer"
       (Jednorazowo utworzyć przy pomocy przyciusku register, potem tylko logować się podanymi przy rejestracji danymi)
       Aby wyłącznie wyświetlać studentów nie trzeba tworzyć konta i służy do tego przycisk "login as guest" 
     - Po jednorazowym logowaniu Aplikacja pobiera dane z access tokena który dostaje w odpowiedzi po zalogowaniu
        i ewentualnie odświeża access token gdy ten wygaśnie przy pomocy refresh tokena więc aby się wylogować i wrócić do ekranu logowania, 
        trzeba nacisnąć przycisk 'logout' który się znajduje w Drawerze lub ewentualnie poczekać, aż refreshtoken straci ważność.
    <DODAWANIE>
      - Aby dodać nowego studenta trzeba kliknąć w ikone plusa na AppBar'rze oraz wypełnić wszystkie pola. (Jest wallidacja jakaś prosta)
      Jeśli nie jesteśmi zalogowani jako admin to wyświetla się na dole komunikat, że dodawać mogą wyłącznie admini
    <Usuwanie>
      - Aby usunąć studenta trzeba klicknąć na ikonę śmietnika przy danym studencie. 
      Jeśli nie jesteśmi zalogowani jako admin to wyświtla się na dole komunikat, że usuwać mogą wyłącznie admini  
    <EDYTOWANIE>
      - Aby usunąć studenta trzeba klicknąć na ikonę długopisu (? albo pióra cokolwiek to jest) przy danym studencie. 
        (to jest generalnie ten sam screen co przy dodawaniu tylko wypełniony)
      Jeśli nie jesteśmi zalogowani jako admin albo developer to wyświetla się na dole komunikat, że edytować mogą wyłącznie admini lub developerzy
    <WYŚWIETLANIE>
      Domyślnie wyświetlają się nam wszyscy studenci, ale jest też zakładka, w której 
      po wpisaniu konkretnego id znajdującego się jeszcze w bazie studenta wyświetla się nam pojedyńczy student
      Jak wpiszemy złe id wyświetla nam się błąd.
# KILKA UWAG:
  - Generalnie skupiłem sie wyłącznie na flutterze i reszta kodu z golanga pozostała tak jak była. 
      (mimo tego że było kilka uwag i na chwilę obecną bym to zadanie inaczej zrobił (i pewnie lepiej/czytelniej). 
      Ale to po prostu wezmę pod uwagę przy następnym zadaniu).
  - Aplikacja sama w sobie nie wygląda jakoś super, ale w głównej mierze miała być prosta i łatwa do testowania kodu z golanga 
      także nie robiłem jakiś skomplikowanych tych podstron i dla wszystkich użytkowników aplikacja jest taka sama, aby łatwiej było testować 
      samo gui we flutterze i walidacje rzeczy
  - Walidacja i jakiś podstawowy errorHandling jest ale bardzo ubogi i napewno mógłby być lepszy
  - Mało komentarzy ale w sumie nie jestem pewny czy były aż tak konieczne tutaj
  - W jednym miejscu dałem losowego printa(), który miał za zadanie, pokazać czy funkcja, która wykorzystuje refresh token działa
  - Przepraszam że tak długo ale przed rozpoczęciem pracy nad tym robiłem sobie ten kursik na udemy co był 
      w załącznikach
