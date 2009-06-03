(load "Lisp-Unit/lisp-unit.lisp")
(use-package :lisp-unit)

(load "Teilnahme.cl")
(load "Termin.cl")
(load "Termin-Repository.cl")
(load "Terminkalender.cl")

(defparameter setup-vars 
  '((repository          (make-instance 'Termin-Repository))
    (stefans-kalender    (make-instance 'Terminkalender :besitzer "Stefan" :repository repository))
    (hennings-kalender   (make-instance 'Terminkalender :besitzer "Henning" :repository repository))
    (martins-kalender    (make-instance 'Terminkalender :besitzer "Martin" :repository repository))
    (ein-datum           (encode-universal-time 0 0 0 12 12 2006))
    (ein-spaeteres-datum (encode-universal-time 0 0 0 13 12 2006))))

(defmacro let-setup (lets &body body)
  `(let* ,(eval lets) ,@body))

(define-test termin-anlegen
  (let-setup setup-vars
    (let* ((dauer-in-minuten 180) 
           (termin           (make-termin stefans-kalender ein-datum dauer-in-minuten "TDD-Dojo")))
      (assert-true  (hat-termin stefans-kalender termin))
      (assert-equal "TDD-Dojo" (beschreibung termin))
      (assert-equal ein-datum (startzeit termin))
      (assert-equal dauer-in-minuten (dauer-in-minuten termin))
      (assert-equal "Stefan" (autor termin)))))

(define-test terminkalender-je-benutzer
  (let-setup setup-vars
    (let* ((termin-stefan  (make-termin stefans-kalender ein-datum 60 "TDD-Dojo"))
           (termin-henning (make-termin hennings-kalender ein-datum 60 "Joggen")))
      (assert-equal (list termin-stefan) (get-termine stefans-kalender t))
      (assert-equal (list termin-henning) (get-termine hennings-kalender t)))))

(define-test terminliste-sortiert-nach-startzeit
  (let-setup setup-vars
    (let* ((termin-1 (make-termin stefans-kalender ein-datum 180 "TDD-Dojo"))
           (termin-3 (make-termin stefans-kalender ein-spaeteres-datum 45 "TDD-Dojo"))
           (termin-2 (make-termin stefans-kalender ein-datum 10 "Meeting mit Müller")))
      (assert-equal (list termin-1 termin-2 termin-3) (get-termine stefans-kalender t)))))

(define-test teilnehmer-einladen-und-autor-ist-auch-teilnehmer
  (let-setup setup-vars
    (let ((termin (make-termin stefans-kalender ein-datum 180 "TDD-Dojo")))
      (lade-teilnehmer-ein termin "Martin")
      (lade-teilnehmer-ein termin "Henning")
      (assert-equality #'set-equal (list "Henning" "Martin" "Stefan") (teilnehmer termin))
      (assert-equal    (list termin) (get-termine stefans-kalender t))
      (assert-equal    (list termin) (get-termine hennings-kalender t)))))

(define-test teilnehmer-koennen-termine-zu-und-absagen
  (let-setup setup-vars
    (let ((termin (make-termin stefans-kalender ein-datum 180 "TDD-Dojo")))
      (lade-teilnehmer-ein termin "Martin")
      (lade-teilnehmer-ein termin "Henning")  
      (assert-equal 'offen (teilnahme-status termin "Martin"))
      (bestaetige-termin termin "Henning")
      (lehne-termin-ab termin "Martin")
      (assert-equal 'bestaetigt (teilnahme-status termin "Henning"))
      (assert-equal 'abgelehnt (teilnahme-status termin "Martin")))))

(define-test autor-sagt-per-default-zu
  (let-setup setup-vars
    (let ((termin (make-termin stefans-kalender ein-datum 180 "TDD-Dojo")))
      (assert-equal 'bestaetigt (teilnahme-status termin "Stefan")))))

(define-test per-default-keine-abgelehnten-termine-anzeigen
  (let-setup setup-vars
    (let ((termin (make-termin stefans-kalender ein-datum 180 "TDD-Dojo")))
      (lade-teilnehmer-ein termin "Henning")
      (lehne-termin-ab termin "Henning")
      (assert-equal '() (get-termine hennings-kalender))
      (assert-equal '() (get-termine martins-kalender t)))))

(define-test auf-wunsch-abgelehnte-termine-anzeigen
  (let-setup setup-vars
    (let ((termin (make-termin stefans-kalender ein-datum 180 "TDD-Dojo")))
      (lade-teilnehmer-ein termin "Henning")
      (lehne-termin-ab termin "Henning")
      (assert-equal (list termin) (get-termine hennings-kalender t))
      (assert-equal '() (get-termine hennings-kalender nil)))))

(define-test benutzer-nicht-eingeladen-exception
  (let-setup setup-vars
    (let ((termin (make-termin stefans-kalender ein-datum 180 "TDD-Dojo")))
      (assert-error 'benutzer-nicht-eingeladen (lehne-termin-ab termin "Henning")))))

(run-tests)
