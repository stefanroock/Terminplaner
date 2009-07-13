:- dynamic(termin_def/4).
:- dynamic(einladung_def/2).
:- dynamic(zusage_def/2).
:- dynamic(absage_def/2).

termin(Autor, Name, Start, Laenge, TerminDef) :- 
	TerminDef = termin_def(Autor, Name, Start, Laenge), 
	assert(TerminDef), 
	assert(einladung_def(TerminDef, Autor)),
	assert(zusage_def(TerminDef, Autor)).

termin_compare(Delta, Termin1, Termin2) :-
	Termin1 = termin_def(_,Name1,Start1,_),
	Termin2 = termin_def(_,Name2,Start2,_),
	date_time_stamp(Start1, Stamp1),
	date_time_stamp(Start2, Stamp2),
	compare(StampDelta, Stamp1, Stamp2),
	compare(NameDelta, Name1, Name2),
	(	StampDelta = =,
 		Delta = NameDelta;
		Delta = StampDelta	).

terminkalender(Benutzer, zeigeAuchAbgelehnteTermine, SortierteTerminListe) :-
	findall(Termin, einladung_def(Termin, Benutzer), TerminListe),
	predsort(termin_compare, TerminListe, SortierteTerminListe). 

terminkalender(Benutzer, SortierteTerminListe) :-
	findall(Termin, (einladung_def(Termin, Benutzer), not(absage_def(Termin, Benutzer))), TerminListe),
	predsort(termin_compare, TerminListe, SortierteTerminListe).

einladung(Termin, Teilnehmer) :- assert(einladung_def(Termin, Teilnehmer)).

absage(Termin, Teilnehmer) :- assert(absage_def(Termin, Teilnehmer)).

zusage(Termin, Teilnehmer) :- einladung_def(Termin, Teilnehmer), assert(zusage_def(Termin, Teilnehmer)).

zusagen(Termin, BenutzerListe) :-
	findall(Benutzer, zusage_def(Termin, Benutzer), BenutzerListe).

absagen(Termin, BenutzerListe) :-
	findall(Benutzer, absage_def(Termin, Benutzer), BenutzerListe).

teilnehmer(Termin, Teilnehmer) :- 
	findall(Zusager, (einladung_def(Termin, Zusager), not(absage_def(Termin, Zusager))), Teilnehmer).

