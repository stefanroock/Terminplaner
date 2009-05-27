import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.SortedSet;
import java.util.TreeSet;

public class Termin implements Comparable {

	private final String _autor;

	private Date _startZeit;

	private int _dauerInMinuten;

	private String _bezeichnung;

	private SortedSet<Teilnahme> _teilnahmen = new TreeSet<Teilnahme>();

	public Termin(String autor, Date startZeit, int dauerInMinuten,
			String bezeichnung) {
		_autor = autor;
		_startZeit = startZeit;
		_dauerInMinuten = dauerInMinuten;
		_bezeichnung = bezeichnung;
		_teilnahmen.add(new Teilnahme(TeilnahmeStatus.BESTAETIGT, autor));
	}

	public String getBezeichnung() {
		return _bezeichnung;
	}

	public int getDauerInMinuten() {
		return _dauerInMinuten;
	}

	public Date getStartZeit() {
		return _startZeit;
	}

	public int compareTo(Object o) {
		if (!(o instanceof Termin))
			return -1;

		int startZeitCompare = getStartZeit().compareTo(
				((Termin) o).getStartZeit());

		if (startZeitCompare == 0)
			return toString().compareTo(((Termin) o).toString());

		return startZeitCompare;
	}

	public String toString() {
		return getStartZeit() + ": " + getBezeichnung() + " ("
				+ getDauerInMinuten() + " Min.)";
	}

	public void ladeTeilnehmerEin(String teilnehmer) {
		_teilnahmen.add(new Teilnahme(teilnehmer));
	}

	public Collection<String> getTeilnehmer() {
		Collection<String> result = new ArrayList<String>();
		for (Teilnahme teilnahme : _teilnahmen) {
			result.add(teilnahme.getTeilnehmer());
		}
		return result;
	}

	public String getAutor() {
		return _autor;
	}

	public TeilnahmeStatus getTeilnahmeStatus(String benutzer)
			throws BenutzerNichtEingeladenException {
		return getTeilnahme(benutzer).getStatus();
	}

	public void bestaetigeTermin(String benutzer)
			throws BenutzerNichtEingeladenException {
		getTeilnahme(benutzer).bestaetige();
	}

	public void lehneTerminAb(String benutzer)
			throws BenutzerNichtEingeladenException {
		getTeilnahme(benutzer).lehneAb();
	}

	void fuegeZuTerminlisteHinzu(Collection<Termin> terminListe,
			String benutzer, boolean zeigeAuchAbgelehnte) {
		boolean benutzerOK = benutzer.equals(getAutor())
				|| _teilnahmen.contains(new Teilnahme(benutzer));
		if (benutzerOK && (zeigeAuchAbgelehnte || istTeilnahmeNochMoeglich(benutzer))) {
			terminListe.add(this);
		}
	}

	private Teilnahme getTeilnahme(String benutzer)
			throws BenutzerNichtEingeladenException {
		for (Teilnahme teilnahme : _teilnahmen) {
			if (teilnahme.getTeilnehmer().equals(benutzer))
				return teilnahme;
		}
		throw new BenutzerNichtEingeladenException();
	}

	private boolean istTeilnahmeNochMoeglich(String benutzer) {
		try {
			Teilnahme teilnahme = getTeilnahme(benutzer);
			return !teilnahme.istAbgelehnt();
		} catch (BenutzerNichtEingeladenException e) {
			return false;
		}
	}

}
