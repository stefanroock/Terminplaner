(defclass Termin-Repository () ((termine :accessor termine :initform nil)))

(defmethod speichere ((r Termin-Repository) (ein-termin Termin)) 
  (push ein-termin (termine r)))

(defmethod termine-zu-benutzer ((r Termin-Repository) benutzer zeige-auch-abgelehnte)
  (remove-if-not #'(lambda (x) 
                     (or (equal (autor x) benutzer) (ist-teilnahme-noch-moeglich x benutzer)
                         (and (teilnahme x benutzer) zeige-auch-abgelehnte)))
                 (termine r)))

(defmethod enthaelt-termin ((r Termin-Repository) (termin Termin))
  (find-if #'(lambda (x) (eq termin x)) (termine r)))
