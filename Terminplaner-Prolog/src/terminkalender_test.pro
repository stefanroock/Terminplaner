% TODO: Sortierung nach Startzeit 
% TODO: assertEquals für Debugging einführen
% TODO: Redundanzen zwischen den Tests beseitigen
% TODO: Unit-Testen durch BDD ersetzen
% TODO: Prüfen, ob Termine das können, was sie in den anderen Lösungen können
% TODO: msort durch predsort(+Pred, +List, -Sorted) ersetzen mit Pred(-Delta, +E1, +E2), Delta mit =, <, >


:- dynamic(termin_def/4).
:- dynamic(einladung_def/2).
:- dynamic(zusage_def/2).
:- dynamic(absage_def/2).

termin(Autor, Name, Start, Laenge, TerminDef) :- 
	TerminDef = termin_def(Autor, Name, Start, Laenge), 
	assert(TerminDef), 
	assert(einladung_def(TerminDef, Autor)),
	assert(zusage_def(TerminDef, Autor)).

terminkalender(Benutzer, true, SortierteTerminListe) :-
	findall(Termin, einladung_def(Termin, Benutzer), TerminListe),
	msort(TerminListe, SortierteTerminListe).

terminkalender(Benutzer, false, SortierteTerminListe) :-
	findall(Termin, (einladung_def(Termin, Benutzer), not(absage_def(Termin, Benutzer))), TerminListe),
	msort(TerminListe, SortierteTerminListe).

terminkalender(Benutzer, SortierteTerminListe) :- terminkalender(Benutzer, false, SortierteTerminListe).

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
	retractall(termin_def(_, _, _, _)), 
	retractall(einladung_def(_,_)),
	retractall(zusage_def(_,_)),
	retractall(absage_def(_,_)),
	retractall(jetzt(_)),
	retractall(spaeter(_)),
	assert(jetzt(Date) :- Date = date(2009,7,13,14,30,0,0,-,-)),
	assert(spaeter(Date) :- Date = date(2009,7,13,14,45,0,0,-,-)).

:- test('...legt Termin an'/(
	jetzt(Jetzt),
	termin(martin, 'OSGi-Talk', Jetzt, 60, _),
	termin_def(martin, 'OSGi-Talk', Jetzt, 60)
)). 

:- test('...liefert Terminliste sortiert nach Startzeit und Bezeichnung'/(
	jetzt(Jetzt), spaeter(Spaeter),
	termin(stefan, 'TDD', Jetzt, 180, Termin1),
	termin(stefan, 'Hang Loose', Spaeter, 240, Termin2),
	termin(martin, "OSGi-Talk", Jetzt, 60, Termin3),
	einladung(Termin3, stefan),
	terminkalender(stefan, TermineStefan),
	TermineStefan == [Termin3, Termin1, Termin2]
)). 

:- test('...verwaltet Termine je Benutzer'/(
	jetzt(Jetzt),
	termin(stefan, 'TDD', Jetzt, 180, TerminStefan),
	termin(martin, 'OSGi-Talk', Jetzt, 60, TerminMartin),
	terminkalender(stefan, TermineStefan),
	TermineStefan == [TerminStefan],
	terminkalender(martin, TermineMartin),
	TermineMartin == [TerminMartin]
)).

:- test('...liefert per Default keine abgelehnten Termine'/(
	jetzt(Jetzt),
	termin(stefan, 'TDD', Jetzt, 180, Termin1),
	termin(stefan, 'Windsurfen', Jetzt, 240, Termin2),
	einladung(Termin1, martin),
	einladung(Termin2, martin),
	absage(Termin1, martin),
	terminkalender(martin, TermineMartin),
	TermineMartin == [Termin2]
)). 

:- test('...liefert auf Wunsch auch abgelehnte Termine'/(
	jetzt(Jetzt),
	termin(stefan, 'TDD', Jetzt, 180, Termin1),
	termin(stefan, 'Windsurfen', Jetzt, 240, Termin2),
	einladung(Termin1, martin),
	einladung(Termin2, martin),
	absage(Termin1, martin),
	terminkalender(martin, true, TermineMartin),
	TermineMartin == [Termin1, Termin2]
)). 

:- end_setup_tests.


:- setup_tests('Termin'). 

:- test('...lädt Benutzer als Teilnehmer ein'/(
	jetzt(Jetzt),
    	termin(martin, 'OSGi-Talk', Jetzt, 60, T),
	einladung(T, henning),
	teilnehmer(T, [martin, henning])
)). 

:- test('...hat den Autoren automatisch als Teilnehmer'/(
	jetzt(Jetzt),
	termin(martin, 'OSGi-Talk', Jetzt, 60, T),
	teilnehmer(T, [martin])
)). 

:- test('...hat automatisch die Zusage des Autoren'/(
	jetzt(Jetzt),
	termin(martin, 'OSGi-Talk', Jetzt, 60, T),
	zusagen(T, [martin])
)). 

:- test('...wird von Teilnehmern zu- oder abgesagt'/(
	jetzt(Jetzt),
	termin(martin, 'OSGi-Talk', Jetzt, 60, T),
	einladung(T, henning),
	einladung(T, stefan),
	absage(T, stefan),
	zusage(T, henning),
	zusagen(T, [martin, henning]),
	absagen(T, [stefan])
)). 

:- test('...darf nur von eingeladenen Teilnehmern zu- oder abgesagt werden'/(
	jetzt(Jetzt),
	termin(martin, 'OSGi-Talk', Jetzt, 60, T),
	einladung(T, henning),
	einladung(T, stefan),
	not(zusage(T, mika))
)). 

:- end_setup_tests.

