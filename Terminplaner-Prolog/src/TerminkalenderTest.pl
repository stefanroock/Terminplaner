:- begin_tests(terminkalender).

termin("Stefan", "TDD", 180).

test(termin) :-
	termin("Stefan", "TDD", 180).

:- end_tests(terminkalender).

