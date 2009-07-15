:- ensure_loaded('../ProSpec/ProSpec.pro').
:- ensure_loaded('terminkalender.pro').

:- setup_specs('Terminkalender'). 

:- dynamic(setup_spec/0).

setup_spec :- 
	retractall(termin_def(_, _, _, _)), 
	retractall(einladung_def(_,_)),
	retractall(zusage_def(_,_)),
	retractall(absage_def(_,_)),
	retractall(jetzt(_)),
	retractall(spaeter(_)),
	assert(jetzt(Jetzt) :- Jetzt = date(2009,7,13,14,30,0,0,-,-)),
	assert(spaeter(Spaeter) :- Spaeter = date(2009,7,13,14,45,0,0,-,-)).


:- spec('...legt Termin an'/(
	jetzt(Jetzt),
	termin(martin, 'OSGi-Talk', Jetzt, 60, _),
	assert_that(termin_def(martin, 'OSGi-Talk', Jetzt, 60), is_true)
)). 

:- spec('...liefert Terminliste sortiert nach Startzeit und Bezeichnung'/(
	jetzt(Jetzt), spaeter(Spaeter),
	termin(stefan, 'TDD', Jetzt, 180, Tdd_Termin),
	termin(stefan, 'Hang Loose', Spaeter, 240, Hang_Loose_Termin),
	termin(martin, 'OSGi-Talk', Jetzt, 60, OSGi_Termin),
	einladung(OSGi_Termin, stefan),
	terminkalender(stefan, TermineStefan),
	assert_that(TermineStefan, equals:[OSGi_Termin, Tdd_Termin, Hang_Loose_Termin])
)). 

:- spec('...verwaltet Termine je Benutzer'/(
	jetzt(Jetzt),
	termin(stefan, 'TDD', Jetzt, 180, TerminStefan),
	termin(martin, 'OSGi-Talk', Jetzt, 60, TerminMartin),
	terminkalender(stefan, TermineStefan),
	assert_that(TermineStefan, equals:[TerminStefan]),
	terminkalender(martin, TermineMartin),
	assert_that(TermineMartin, equals:[TerminMartin])
)).

:- spec('...liefert per Default keine abgelehnten Termine'/(
	jetzt(Jetzt),
	termin(stefan, 'TDD', Jetzt, 180, Termin1),
	termin(stefan, 'Windsurfen', Jetzt, 240, Termin2),
	einladung(Termin1, martin),
	einladung(Termin2, martin),
	absage(Termin1, martin),
	terminkalender(martin, TermineMartin),
	assert_that(TermineMartin, equals:[Termin2])
)). 

:- spec('...liefert auf Wunsch auch abgelehnte Termine'/(
	jetzt(Jetzt),
	termin(stefan, 'TDD', Jetzt, 180, Termin1),
	termin(stefan, 'Windsurfen', Jetzt, 240, Termin2),
	einladung(Termin1, martin),
	einladung(Termin2, martin),
	absage(Termin1, martin),
	terminkalender(martin, zeigeAuchAbgelehnteTermine, TermineMartin),
	assert_that(TermineMartin, equals:[Termin1, Termin2])
)). 

:- end_setup_specs.


:- setup_specs('Termin'). 

:- spec('...lädt Benutzer als Teilnehmer ein'/(
	jetzt(Jetzt),
    	termin(martin, 'OSGi-Talk', Jetzt, 60, T),
	einladung(T, henning),
	teilnehmer(T, [martin, henning])
)). 

:- spec('...hat den Autoren automatisch als Teilnehmer'/(
	jetzt(Jetzt),
	termin(martin, 'OSGi-Talk', Jetzt, 60, T),
	teilnehmer(T, [martin])
)). 

:- spec('...hat automatisch die Zusage des Autoren'/(
	jetzt(Jetzt),
	termin(martin, 'OSGi-Talk', Jetzt, 60, T),
	zusagen(T, [martin])
)). 

:- spec('...wird von Teilnehmern zu- oder abgesagt'/(
	jetzt(Jetzt),
	termin(martin, 'OSGi-Talk', Jetzt, 60, T),
	einladung(T, henning),
	einladung(T, stefan),
	absage(T, stefan),
	zusage(T, henning),
	zusagen(T, [martin, henning]),
	absagen(T, [stefan])
)). 

:- spec('...darf nur von eingeladenen Teilnehmern zu- oder abgesagt werden'/(
	jetzt(Jetzt),
	termin(martin, 'OSGi-Talk', Jetzt, 60, T),
	einladung(T, henning),
	einladung(T, stefan),
	not(zusage(T, mika))
)). 

:- end_setup_specs.

