% TODO: Startzeit (date) in Termin aufnehmen
% TODO: Sortierung nach Startzeit 
% TODO: Gibt es sowas wie OO in Prolog (Klasse date)?
% TODO: assertEquals für Debugging einführen
% TODO: Redundanzen zwischen den Tests beseitigen
% TODO: Unit-Testen durch BDD ersetzen



:- dynamic(termin_def/3).
:- dynamic(einladung_def/2).
:- dynamic(zusage_def/2).
:- dynamic(absage_def/2).

termin(Autor, Name, Laenge, TerminDef) :- 
	TerminDef = termin_def(Autor, Name, Laenge), 
	assert(TerminDef), 
	assert(einladung_def(TerminDef, Autor)),
	assert(zusage_def(TerminDef, Autor)).

terminkalender(Benutzer, SortierteTerminListe) :-
	findall(Termin, einladung_def(Termin, Benutzer), TerminListe),
	msort(TerminListe, SortierteTerminListe).

einladung(Termin, Teilnehmer) :- assert(einladung_def(Termin, Teilnehmer)).

absage(Termin, Teilnehmer) :- assert(absage_def(Termin, Teilnehmer)).

zusage(Termin, Teilnehmer) :- einladung_def(Termin, Teilnehmer), assert(zusage_def(Termin, Teilnehmer)).

zusagen(Termin, BenutzerListe) :-
	findall(Benutzer, zusage_def(Termin, Benutzer), BenutzerListe).

absagen(Termin, BenutzerListe) :-
	findall(Benutzer, absage_def(Termin, Benutzer), BenutzerListe).

teilnehmer(Termin, Teilnehmer) :- 
	findall(Zusager, (einladung_def(Termin, Zusager), not(absage_def(Termin, Zusager))), Teilnehmer).

:- setup_tests('Terminkalender'). 

:- dynamic(setup_test/0).

setup_test :- 
	retractall(termin_def(_, _, _)), 
	retractall(einladung_def(_,_)),
	retractall(zusage_def(_,_)),
	retractall(absage_def(_,_)).

:- test('...legt Termin an'/(
	termin(martin, 'OSGi-Talk', 60, _),
	termin_def(martin, 'OSGi-Talk', 60)
)). 

:- test('...liefert Terminliste sortiert nach Startzeit und Bezeichnung'/(
	termin(stefan, 'TDD', 180, Termin1),
	termin(stefan, 'Windsurfen', 240, Termin2),
	termin(martin, "OSGi-Talk", 60, Termin3),
	einladung(Termin3, stefan),
	terminkalender(stefan, TermineStefan),
	TermineStefan == [Termin1, Termin2, Termin3]
)). 

:- test('...verwaltet Termine je Benutzer'/(
	termin(stefan, 'TDD', 180, TerminStefan),
	termin(martin, 'OSGi-Talk', 60, TerminMartin),
	terminkalender(stefan, TermineStefan),
	TermineStefan == [TerminStefan],
	terminkalender(martin, TermineMartin),
	TermineMartin == [TerminMartin]
)).

:- test('...liefert per Default keine abgelehnten Termine'/(
    true % TBD
)). 

:- test('...liefert auf Wunsch auch abgelehnten Termine'/(
    true % TBD
)). 

:- end_setup_tests.


:- setup_tests('Termin'). 

:- test('...lädt Benutzer als Teilnehmer ein'/(
    	termin(martin, 'OSGi-Talk', 60, T),
	einladung(T, henning),
	teilnehmer(T, [martin, henning])
)). 

:- test('...hat den Autoren automatisch als Teilnehmer'/(
	termin(martin, 'OSGi-Talk', 60, T),
	teilnehmer(T, [martin])
)). 

:- test('...hat automatisch die Zusage des Autoren'/(
	termin(martin, 'OSGi-Talk', 60, T),
	zusagen(T, [martin])
)). 

:- test('...wird von Teilnehmern zu- oder abgesagt'/(
	termin(martin, 'OSGi-Talk', 60, T),
	einladung(T, henning),
	einladung(T, stefan),
	absage(T, stefan),
	zusage(T, henning),
	zusagen(T, [martin, henning]),
	absagen(T, [stefan])
)). 

:- test('...darf nur von eingeladenen Teilnehmern zu- oder abgesagt werden'/(
	termin(martin, 'OSGi-Talk', 60, T),
	einladung(T, henning),
	einladung(T, stefan),
	not(zusage(T, mika))
)). 

:- end_setup_tests.

