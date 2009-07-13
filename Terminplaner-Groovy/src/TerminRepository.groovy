public class TerminRepository {

	private SortedSet termine =  [] as SortedSet
	
	public void speichere(Termin t) {
		termine << t		
	}

	public boolean hatTermin(Termin termin) {
		termine.contains termin
	}

	public Collection getTermine(String besitzer, boolean zeigeAuchAbgelehnte) {
//		termine.findAll { termin -> termin.isSichtbar(besitzer, zeigeAuchAbgelehnte) }.sort()

		return termine.inject([]) {result, termin ->
			termin.fuegeZuTerminlisteHinzu(result, besitzer, zeigeAuchAbgelehnte)  // TDA: Tell, don't ask
			result
		}
	}
		
}
