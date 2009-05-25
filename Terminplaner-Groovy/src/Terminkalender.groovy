public class Terminkalender {

	final String _besitzer
	final TerminRepository _repository
	
	Terminkalender(TerminRepository repository, String besitzer) {
		_repository = repository
		_besitzer = besitzer
	}
	
	Termin newTermin(Date jetzt, int dauerInMinuten, String bezeichnung) {
		Termin t = new Termin(_besitzer, jetzt, dauerInMinuten, bezeichnung)
		_repository.speichere(t)
		return t
	}

	Boolean hatTermin(Termin termin) {
		return _repository.hatTermin(termin)
	}

	Collection getAlleTermine() {
		return getTermine()
	}
	
	Collection getTermine(Boolean zeigeAuchAbgelehnte) {
		return _repository.getTermine(_besitzer, zeigeAuchAbgelehnte)
	}

}
