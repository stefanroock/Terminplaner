import java.util.ArrayList;
import java.util.Collection;
import java.util.SortedSet;
import java.util.TreeSet;

public class TerminRepository {

	private SortedSet<Termin> _termine =  new TreeSet<Termin>();
	
	public void speichere(Termin t) {
		_termine.add(t);		
	}

	public boolean hatTermin(Termin termin) {
		return _termine.contains(termin);
	}

	public Collection<Termin> getTermine(String besitzer, boolean zeigeAuchAbgelehnte) {
		Collection<Termin> result = new ArrayList<Termin>();
		for (Termin termin : _termine) {
			termin.fuegeZuTerminlisteHinzu(result, besitzer, zeigeAuchAbgelehnte);  // TDA: Tell, don't ask
		}
		return result;
	}
		
}
