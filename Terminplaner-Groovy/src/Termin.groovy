public class Termin implements Comparable {

	String autor
	Date startZeit
	int dauerInMinuten
	String bezeichnung
	SortedSet teilnahmen = [] as SortedSet

	Termin(String autor, Date startZeit, int dauerInMinuten, String bezeichnung) {
		this.autor = autor
		this.startZeit = startZeit
		this.dauerInMinuten = dauerInMinuten
		this.bezeichnung = bezeichnung
		teilnahmen << new Teilnahme(Teilnahme.BESTAETIGT, autor)
	}

	int compareTo(Object o) {
		int startZeitCompare = startZeit <=> o.startZeit
		startZeitCompare != 0 ? startZeitCompare : toString() <=> o.toString()
	}

	String toString() {
		"$startZeit: $bezeichnung ($dauerInMinuten Min.)"
	}

	void ladeTeilnehmerEin(String teilnehmer) {
	  	teilnahmen << new Teilnahme(teilnehmer)
	}

	Collection getTeilnehmer() {
		return teilnahmen.inject([]) {result, teilnahme ->
		  	result << teilnahme.teilnehmer
	    	}
	}

	int getTeilnahmeStatus(String benutzer) {
		getTeilnahme(benutzer).status
	}

	void bestaetigeTermin(String benutzer) {
		getTeilnahme(benutzer).bestaetige()
	}

	void lehneTerminAb(String benutzer) {
		getTeilnahme(benutzer).lehneAb()
	}

	void fuegeZuTerminlisteHinzu(Collection terminListe, String benutzer, boolean zeigeAuchAbgelehnte) {			
		boolean benutzerOK = benutzer == autor || teilnahmen.contains(new Teilnahme(benutzer))
		if (benutzerOK && (zeigeAuchAbgelehnte || istTeilnahmeNochMoeglich(benutzer))) {
			terminListe << this
		}
	}

	private Teilnahme getTeilnahme(String benutzer) {
		Teilnahme result = teilnahmen.find{ benutzer == it.teilnehmer }
		if (result != null) return result
		throw new BenutzerNichtEingeladenException()
	}

	private boolean istTeilnahmeNochMoeglich(String benutzer) {
		try {
			return !getTeilnahme(benutzer).abgelehnt
		} catch (BenutzerNichtEingeladenException e) {
			return false
		}
	}

}
