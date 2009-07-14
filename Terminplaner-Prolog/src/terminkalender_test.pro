% TODO: Prüfen, ob Termine das können, was sie in den anderen Lösungen können

:- ensure_loaded('plunit.pro').
:- ensure_loaded('terminkalender.pro').

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
	jetzt(Jetzt), 
	spaeter(Spaeter),
	termin(stefan, 'TDD', Jetzt, 180, Termin1),
	termin(stefan, 'Hang Loose', Spaeter, 240, Termin2),
	termin(martin, 'OSGi-Talk', Jetzt, 60, Termin3),
	einladung(Termin3, stefan),
	terminkalender(stefan, TermineStefan),
	assert_that(TermineStefan, equals([Termin3, Termin1, Termin2]))
)). 

:- test('...verwaltet Termine je Benutzer'/(
	jetzt(Jetzt),
	termin(stefan, 'TDD', Jetzt, 180, TerminStefan),
	termin(martin, 'OSGi-Talk', Jetzt, 60, TerminMartin),
	terminkalender(stefan, TermineStefan),
	assert_that(TermineStefan, equals([TerminStefan])),
	terminkalender(martin, TermineMartin),
	assert_that(TermineMartin, equals([TerminMartin]))
)).

:- test('...liefert per Default keine abgelehnten Termine'/(
	jetzt(Jetzt),
	termin(stefan, 'TDD', Jetzt, 180, Termin1),
	termin(stefan, 'Windsurfen', Jetzt, 240, Termin2),
	einladung(Termin1, martin),
	einladung(Termin2, martin),
	absage(Termin1, martin),
	terminkalender(martin, TermineMartin),
	assert_that(TermineMartin, equals([Termin2]))
)). 

:- test('...liefert auf Wunsch auch abgelehnte Termine'/(
	jetzt(Jetzt),
	termin(stefan, 'TDD', Jetzt, 180, Termin1),
	termin(stefan, 'Windsurfen', Jetzt, 240, Termin2),
	einladung(Termin1, martin),
	einladung(Termin2, martin),
	absage(Termin1, martin),
	terminkalender(martin, zeigeAuchAbgelehnteTermine, TermineMartin),
	assert_that(TermineMartin, equals([Termin1, Termin2]))
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

