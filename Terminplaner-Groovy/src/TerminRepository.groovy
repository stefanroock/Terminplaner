public class TerminRepository {

	private SortedSet _termine =  new TreeSet()
	
	public void speichere(Termin t) {
		_termine << t		
	}

	public Boolean hatTermin(Termin termin) {
		return _termine.contains(termin)
	}

	public Collection getTermine(String besitzer, Boolean zeigeAuchAbgelehnte) {
		Collection result = new ArrayList()
		_termine.each {
			it.fuegeZuTerminlisteHinzu(result, besitzer, zeigeAuchAbgelehnte)  // TDA: Tell, don't ask
		}
		return result
	}
		
}
