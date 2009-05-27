import sets

class TerminRepository:
    
    def __init__(self):
        self.__termine = sets.Set()

    def speichere(self, termin):
        self.__termine.add(termin)
        
    def hat_termin(self, termin):
        return termin in self.__termine
    
    def termine(self, besitzer, zeige_auch_abgelehnte):
        def f(x): return x.besitzer==besitzer
        return filter(f, self.__termine)


##	public Collection<Termin> getTermine(String besitzer, boolean zeigeAuchAbgelehnte) {
##		Collection<Termin> result = new ArrayList<Termin>();
##		for (Termin termin : _termine) {
##			termin.fuegeZuTerminlisteHinzu(result, besitzer, zeigeAuchAbgelehnte);  // TDA: Tell, don't ask
##		}
##		return result;
##	}
