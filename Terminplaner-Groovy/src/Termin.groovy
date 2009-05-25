public class Termin implements Comparable {

	@Property String autor

	@Property Date startZeit

	@Property int dauerInMinuten

	@Property String bezeichnung

	SortedSet _teilnahmen = new TreeSet()

	Termin(String einAutor, Date eineStartZeit, int eineDauerInMinuten,
			String eineBezeichnung) {
		autor = einAutor
		startZeit = eineStartZeit
		dauerInMinuten = eineDauerInMinuten
		bezeichnung = eineBezeichnung
		_teilnahmen.add( new Teilnahme(Teilnahme.BESTAETIGT, einAutor) )
	}

	int compareTo(Object o) {
		int startZeitCompare = startZeit <=> o.startZeit

		if (startZeitCompare == 0) return toString() <=> o.toString()

		return startZeitCompare
	}

	String toString() {
		return "" + startZeit + ": " + bezeichnung + " ("
				+ dauerInMinuten + " Min.)"
	}

	void ladeTeilnehmerEin(String einTeilnehmer) {
	   _teilnahmen.add(new Teilnahme(einTeilnehmer))
	}

	Collection getTeilnehmer() {
		Collection result = new ArrayList()
		_teilnahmen.each{
		  	result.add(it.teilnehmer)
	    }
		return result
	}

	int getTeilnahmeStatus(String benutzer) {
		return getTeilnahme(benutzer).status
	}

	void bestaetigeTermin(String benutzer) {
		getTeilnahme(benutzer).bestaetige()
	}

	void lehneTerminAb(String benutzer) {
		getTeilnahme(benutzer).lehneAb()
	}

	void fuegeZuTerminlisteHinzu(Collection terminListe,
			String benutzer, Boolean zeigeAuchAbgelehnte) {			
		Boolean benutzerOK = benutzer == autor || _teilnahmen.contains(new Teilnahme(benutzer))
		if (benutzerOK && (zeigeAuchAbgelehnte || istTeilnahmeNochMoeglich(benutzer))) {
			terminListe.add(this)
		}
	}

	private Teilnahme getTeilnahme(String benutzer) {
		Teilnahme result = null
		_teilnahmen.each{
			if (benutzer == it.teilnehmer) {
				result = it
		    }
		}
		if (result == null) {
			throw new BenutzerNichtEingeladenException()
		} else {
			return result
		}
	}

	private Boolean istTeilnahmeNochMoeglich(String benutzer) {
		try {
			Teilnahme teilnahme = getTeilnahme(benutzer)
			return !teilnahme.istAbgelehnt()
		} catch (BenutzerNichtEingeladenException e) {
			return false
		}
	}

}
