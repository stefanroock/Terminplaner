(defclass Teilnahme () ((teilnehmer :accessor teilnehmer :initarg :teilnehmer) 
                        (status :accessor status :initarg :status :initform 'offen)))

(defmethod bestaetige ((tn Teilnahme)) (setf (status tn) 'bestaetigt))

(defmethod lehne-ab ((tn Teilnahme)) (setf (status tn) 'abgelehnt))

(defmethod ist-abgelehnt ((tn Teilnahme)) (eql (status tn) 'abgelehnt))
