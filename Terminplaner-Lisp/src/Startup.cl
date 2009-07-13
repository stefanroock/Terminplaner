(load "Teilnahme.cl")
(load "Termin.cl")
(load "Termin-Repository.cl")
(load "Terminkalender.cl")

(defparameter repository (make-instance 'Termin-Repository))
(defparameter kalender (make-instance 'Terminkalender :besitzer "Stefan" :repository repository))
(defparameter termin1 (make-termin kalender "18:00" 120 "Abendessen"))

(print termin1)
