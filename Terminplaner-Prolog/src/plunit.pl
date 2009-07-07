% http://www.kenegozi.com/blog/2008/07/27/unit-testing-in-prolog-take-2.aspx
% with minor modification by Stefan Roock

test(Fact/Test):-
    current_predicate_under_test(Predicate),
    retractall(test_def(Predicate/Fact/Test)),
    assert(test_def(Predicate/Fact/Test)). 
 
setup_tests(Predicate) :-
    retractall(test_def(Predicate/_/_)),
    assert(current_predicate_under_test(Predicate)). 
 
end_setup_tests:-
    retractall(current_predicate_under_test(_)). 
 
run_one_test(Pred/Name) :-
	test_def(Pred/Name/Test),
	call(Test).

run_tests :-
    dynamic(setup_test/0),
    dynamic(tests_stats/2),
    write('Testing '), nl,
    bagof(P/Tests, bagof((Fact/Test), test_def(P/Fact/Test), Tests), TestsPerPredicate),
    run_tests(TestsPerPredicate, Passed/Failed),
    write_tests_summary(Passed/Failed). 
 
run_tests(TestsTestsPerPredicate, TotalPassed/TotalFailed) :-
    run_tests(TestsTestsPerPredicate, 0/0, TotalPassed/TotalFailed). 
 
run_tests([], Passed/Failed, Passed/Failed):-!. 

run_tests([P/Tests|Rest], Passed/Failed, TotalPassed/TotalFailed):-
    nl, write(P), nl,
    foreach_test(Tests, PassedInPredicate/FailedInPredicate),
    write('Passed:'), write(PassedInPredicate),
    (FailedInPredicate > 0, write(' Failed:'), write(FailedInPredicate) ; true),
    nl,
    Passed1 is Passed + PassedInPredicate,
    Failed1 is Failed + FailedInPredicate,
    run_tests(Rest, Passed1/Failed1, TotalPassed/TotalFailed). 
 
foreach_test(Tests, Passed/Failed):-
    foreach_test(Tests, 0/0, Passed/Failed). 
 
foreach_test([], Passed/Failed, Passed/Failed):-!. 
foreach_test([Fact/Test|Rest], Passed/Failed, NewPassed/NewFailed):-
    assert((run_test:-Test)),
    (
%        run_test, !,
	setup_test, call(Test), !,
        NextPassed is Passed + 1,
        NextFailed is Failed,
        write(Fact), write(' (passed)'), nl
    ;
        NextFailed is Failed + 1,
        NextPassed is Passed,
        write(Fact), write(' (FAILED)'), nl
    ),
    retract((run_test:-Test)),
    foreach_test(Rest, NextPassed/NextFailed, NewPassed/NewFailed). 
 
write_tests_summary(Passed/0) :- !,
    nl,
    write(Passed), write(' tests passed'),
    nl. 
write_tests_summary(Passed/Failed) :-
    nl,
    write(Passed), write(' tests passed,'), nl,
    write(Failed), write(' tests failed'),
    nl. 
 
reset_all_tests:-
    retractall(test_def(_/_/_)).


run_test(Test) :-
    call(Test),!,
    tests_passed(X),
    retract(tests_passed(X)),
    NewX is X + 1,
    assert(tests_passed(NewX)).
run_test(Test) :-
    failing_tests(X),
    retract(failing_tests(X)),
    NewX = [Test|X],
    assert(failing_tests(NewX)).

% Asserts
assert_all_members_equal_to([], _).
assert_all_members_equal_to([H|T], H) :-
    assert_all_members_equal_to(T, H). 

