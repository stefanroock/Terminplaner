import datetime
import Teilnahme

class Termin:
    
    def __init__(self, besitzer, startzeit, dauer_in_minuten, bezeichnung):
        self.__teilnahmen = [Teilnahme(besitzer, Teilnahme.bestaetigt)]
        self.besitzer = besitzer
        self.startzeit = startzeit
        self.dauer_in_minuten = dauer_in_minuten
        self.bezeichnung = bezeichnung
        self.autor = besitzer

    def __str__(self):
        return "" + str(self.startzeit) + ": " + self.bezeichnung
    
    def bestaetige_termin(self, teilnehmer):
        pass
    
    def lehne_termin_ab(self, teilnehmer):
        pass
        
    def teilnahme(self, teilnehmer):
        pass
    