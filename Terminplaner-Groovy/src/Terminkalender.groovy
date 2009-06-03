public class Terminkalender {

	final String besitzer
	final TerminRepository repository
	
	Terminkalender(TerminRepository repository, String besitzer) {
		this.repository = repository
		this.besitzer = besitzer
	}
	
	Termin newTermin(Date jetzt, int dauerInMinuten, String bezeichnung) {
		Termin t = new Termin(besitzer, jetzt, dauerInMinuten, bezeichnung)
		repository.speichere t
		t
	}

	Boolean hatTermin(Termin termin) {
		repository.hatTermin termin
	}

	Collection getAlleTermine() {
		getTermine false
	}
	
	Collection getTermine(boolean zeigeAuchAbgelehnte) {
		repository.getTermine besitzer, zeigeAuchAbgelehnte
	}

}
