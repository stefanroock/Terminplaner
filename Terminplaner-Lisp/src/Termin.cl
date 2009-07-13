(defclass Termin () ((autor :accessor autor :initarg :autor)
                     (startzeit :accessor startzeit :initarg :startzeit) 
                     (dauer-in-minuten :accessor dauer-in-minuten :initarg :dauer-in-minuten) 
                     (beschreibung :accessor beschreibung :initarg :beschreibung)
                     (teilnahmen :accessor teilnahmen :initform)))

(defmethod initialize-instance :after ((instance Termin) &rest initargs &key &allow-other-keys)
    (setf (teilnahmen instance) (list (make-instance 'Teilnahme :teilnehmer (autor instance) :status 'bestaetigt))))

(defmethod lade-teilnehmer-ein ((term Termin) teilnehmer) 
  (push (make-instance 'Teilnahme :teilnehmer teilnehmer) (teilnahmen term)))

(defmethod teilnehmer ((term Termin))
  (map 'list #'teilnehmer (teilnahmen term)))


(defmethod teilnahme ((term Termin) benutzer)
  (find-if #'(lambda (x) (equal x benutzer)) (teilnahmen term) :key #'teilnehmer))

(defmethod teilnahme-status ((term Termin) benutzer)
  (status (teilnahme term benutzer)))

(defmethod bestaetige-termin ((term Termin) benutzer)
  (bestaetige (teilnahme term benutzer)))

(define-condition benutzer-nicht-eingeladen () nil)

(defmethod lehne-termin-ab ((term Termin) benutzer)
  (let ((tn (teilnahme term benutzer)))
    (unless tn (signal 'benutzer-nicht-eingeladen))
    (lehne-ab tn)))

(defmethod ist-teilnahme-noch-moeglich ((term Termin) benutzer)
  (let ((tn (teilnahme term benutzer)))
    (and tn (not (ist-abgelehnt (teilnahme term benutzer))))))

