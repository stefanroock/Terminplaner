class Teilnahme:
    
    offen = "offen"
    bestaetigt = "best?tigt"
    abgelehnt = "abgelehnt"
    
    def __init__(self, teilnehmer, status=offen):
        self.teilnehmer = teilnehmer
        self.status = status
        