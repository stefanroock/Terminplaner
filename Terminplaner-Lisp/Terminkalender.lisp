(defclass Terminkalender () ((besitzer :initarg :besitzer :accessor besitzer) 
                             (repository :initarg :repository :accessor repository)))

(defmethod make-termin ((k Terminkalender) datum dauer-in-minuten bezeichnung) 
  (let ((termin (make-instance 'Termin 
                               :autor (besitzer k) 
                               :startzeit datum 
                               :dauer-in-minuten dauer-in-minuten 
                               :beschreibung bezeichnung)))
    (speichere (repository k) termin)
    termin))

(defmethod hat-termin ((k Terminkalender) (einTermin Termin)) 
  (enthaelt-termin (repository k) einTermin))

(defmethod get-termine ((k Terminkalender) &optional (zeige-auch-abgelehnte nil)) 
  (sort (termine-zu-benutzer (repository k) (besitzer k) zeige-auch-abgelehnte) #'<= 
        :key (lambda (termin) (startzeit termin))))

