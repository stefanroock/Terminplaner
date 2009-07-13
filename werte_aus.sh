./cloc-1.08.pl --no3 --read-lang-def=cloc_definitions.txt -not-match-f=.*Test.java Terminplaner-Java/src > Auswertung.txt
./cloc-1.08.pl --no3 --read-lang-def=cloc_definitions.txt -match-f=.*Test.java Terminplaner-Java/src >> Auswertung.txt
./cloc-1.08.pl --no3 --read-lang-def=cloc_definitions.txt -not-match-f=.*Test.groovy Terminplaner-Groovy/src >> Auswertung.txt
./cloc-1.08.pl --no3 --read-lang-def=cloc_definitions.txt -match-f=.*Test.groovy Terminplaner-Groovy/src >> Auswertung.txt
./cloc-1.08.pl --no3 --read-lang-def=cloc_definitions.txt -not-match-f=.*Test.rb Terminplaner-Ruby/src >> Auswertung.txt
./cloc-1.08.pl --no3 --read-lang-def=cloc_definitions.txt -match-f=.*Test.rb Terminplaner-Ruby/src >> Auswertung.txt
./cloc-1.08.pl --no3 --read-lang-def=cloc_definitions.txt -not-match-f=.*-Test.cl Terminplaner-Lisp/src >> Auswertung.txt
./cloc-1.08.pl --no3 --read-lang-def=cloc_definitions.txt -match-f=.*-Test.cl Terminplaner-Lisp/src >> Auswertung.txt
./cloc-1.08.pl --no3 --read-lang-def=cloc_definitions.txt -not-match-f=.*_test.pro Terminplaner-Prolog/src >> Auswertung.txt
./cloc-1.08.pl --no3 --read-lang-def=cloc_definitions.txt -match-f=.*_test.pro Terminplaner-Prolog/src >> Auswertung.txt

