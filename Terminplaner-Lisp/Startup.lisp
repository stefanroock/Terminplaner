(load "Teilnahme.lisp")
(load "Termin.lisp")
(load "Termin-Repository.lisp")
(load "Terminkalender.lisp")

(defparameter repository (make-instance 'Termin-Repository))
(defparameter kalender (make-instance 'Terminkalender :besitzer "Stefan" :repository repository))
(defparameter termin1 (make-termin kalender "18:00" 120 "Abendessen"))

(print termin1)
