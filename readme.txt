Witam, udało mi się poprawić (chyba) wszystkie rzeczy, z najważniejszych zmian:
- Naprawiłem swaggery. Endpointy teraz nie tylko są, ale nawet działają. Można z nich korzystać, obsługują tez JWT token (jednak od razu uprzedzam, że wersja swaggera, z której korzystałem, nie dodaje przedrostka "Bearer " do headera "Authorization" i trzeba go wpisać ręcznie. (w sensie mój kod generuje sam [token] a do swaggera trzeba wpisać "Bearer [token]". Szukałem rozwiązania w dokumentacji oraz na jakiś forach, ale nic sensownego nie znalazłem) http://localhost:8080/swagger/index.html
- JWT w końcu działa. Korzystając z Pana porady, zrezygnowałem z redisa i zamiast tego użyłem po prostu tabeli w bazie. Po zalogowaniu się na /login user dostaje access token i refresh token, które zapisuje w bazie. W headerze "Authorization" user podaje access token i jeśli token jest ważny, a user ma odpowiednią rolę, to wykonywane jest zapytanie. Jeśli access token wygaśnie, to jeśli user wejdzie /refresh i w jsonie przesyła "refresh_token", który jest ważny to user dostaje nową parę tokenów, a poprzednie są usuwane. Jeśli refresh token wygaśnie, to user musi się od nowa zalogować. Tak to miało mniej więcej działać nie?
- Dodałem możliwość wyświetlania 1 studenta (szybciej nie było w poleceniu :) )
- Zainicjowałem plik go.mod i wygląda na to, że teraz działa.
- Ponadto poprawiłem jakieś pomniejsze rzeczy odnośnie do np. nazewnictwa, czy struktury repo

!!!! 
Do testowania aplikacji używałem Postmana i Swaggera. W postmanie aby zobaczyc czy JWT działa to po udanym zalogowaniu user dostaje access token który należy umiescić w headerze "Authorization" i jeśli user ma odpowiednią role (admin albo developer) to zapytanie się wykona. W swaggerze trzeba przed tokenem dopisać "Bearer ". Dostępne endpointy wszystkie wypisane są pod adresem http://localhost:8080/swagger/index.html po uruchomieniu programu.
!!! 

Rzeczy których nie wprowadziłem (a pewnie fajnie by było gdbyby były):
- Walidacja danych usera przy rejestracji (w poleceniu nic o walidacji nie było, z początku chciałem wprowadzić sam z siebie, ale przez komplikacje z redisem który zabrał z 3/4 czasu jaki poświęciłem na ten projekt (i jeszcze nie działał xD) stwierdziłem, że odpuszczę i najwyżej tego typu rzeczy przy następnych projektach pododaje)
- Frontend mógłby być wzbogacony też o obsługę tych tokenów (Powód dlaczego nie zostało to wprowadzone w sumie ten sam co wyżej. I tak z tego co zrozumiałem on miał po prostu być, żebym mógł się zaznajomić z odbiorem danych z backendu, to już zostawiłem tak jak był po zadaniu 2)
