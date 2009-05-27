import java.util.Collection;
import java.util.Date;

public class Terminkalender {

	private final String _besitzer;
	private final TerminRepository _repository;
	
	public Terminkalender(TerminRepository repository, String besitzer) {
		_repository = repository;
		_besitzer = besitzer;
	}
	
	public Termin newTermin(Date jetzt, int dauerInMinuten, String bezeichnung) {
		Termin t = new Termin(_besitzer, jetzt, dauerInMinuten, bezeichnung);
		_repository.speichere(t);
		return t;
	}

	boolean hatTermin(Termin termin) {
		return _repository.hatTermin(termin);
	}

	public Collection<Termin> getTermine() {
		return getTermine(False);
	}

	public Collection<Termin> getTermine(boolean zeigeAuchAbgelehnte) {
		return _repository.getTermine(_besitzer, zeigeAuchAbgelehnte);
	}

}
