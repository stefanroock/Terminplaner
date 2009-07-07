:- setup_tests('termin/3'). 

:- termin('Stefan', 'TDD', 180).

Termine = [termin(stefan, "TDD", 180), termin(henning, "Scrum", 400)].

gruppe(admin, stefan).
gruppe(admin, mika).
selbe_gruppe(Benutzer1, Benutzer2) :- gruppe(Gruppe, Benutzer1), gruppe(Gruppe, Benutzer2). 

alle_termine(Benutzer) :- alle_termine(Benutzer, true).

termine([], Benutzer, Auch_Abgelehnte, Ergebnis).
termine([T], Benutzer, Auch_Abgelehnte, Ergebnis) :- termin(T, Benutzer, _).
termine([T|Termine], Benutzer, Auch_Abgelehnte, Ergebnis) :- termine(Termine, Benutzer,  Auch_Abgelehnte, [T|Ergebnis]).

:- test('termin ok'/(
    termin('Stefan', 'TDD', 180)
)). 

:- end_setup_tests.

