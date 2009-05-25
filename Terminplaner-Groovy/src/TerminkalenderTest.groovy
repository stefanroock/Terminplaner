public class TerminkalenderTest extends GroovyTestCase {

	static final String STEFAN = "Stefan", HENNING = "Henning",
			MARTIN = "Martin"

	TerminRepository _terminRepository = new TerminRepository()

	Calendar _calendar = Calendar.instance

	Date _jetzt = _calendar.time

	Date _spaeter = new Date(_jetzt.time + 10000)

	Terminkalender _stefansKalender = new Terminkalender(
			_terminRepository, STEFAN)

	Terminkalender _henningsKalender = new Terminkalender(
			_terminRepository, HENNING)

	Terminkalender _martinsKalender = new Terminkalender(
			_terminRepository, MARTIN)
	
	void testTerminAnlegen() {
		int dauerInMinuten = 180
		Termin termin = _stefansKalender.newTermin(_jetzt, dauerInMinuten,
				"TDD-Dojo")
		assertTrue(_stefansKalender.hatTermin(termin))
		assertEquals("TDD-Dojo", termin.bezeichnung)
		assertEquals(_jetzt, termin.startZeit)
		assertEquals(dauerInMinuten, termin.dauerInMinuten)
		assertEquals(STEFAN, termin.autor)
	}

	void testTerminlisteSortiertNachStartzeit() {
		Termin termin2 = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo")
		Termin termin3 = _stefansKalender.newTermin(_spaeter, 45, "TDD-Dojo")
		Termin termin1 = _stefansKalender.newTermin(_jetzt, 10,
				"Meeting mit Müller")

		assertEquals([termin1, termin2, termin3], _stefansKalender.alleTermine)
	}

	void testTerminkalenderJeBenutzer() {
		Termin terminStefan = _stefansKalender.newTermin(_jetzt, 180,
				"TDD-Dojo")
		Termin terminHenning = _henningsKalender.newTermin(_spaeter, 60,
				"Joggen")

		assertEquals([terminStefan], _stefansKalender.alleTermine)
		assertEquals([terminHenning], _henningsKalender.alleTermine)
	}

	void testTeilnehmerEinladenUndAutorIstAuchTeilnehmer() {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo")
		termin.ladeTeilnehmerEin(MARTIN)
		termin.ladeTeilnehmerEin(HENNING)

		assertEquals([HENNING, MARTIN, STEFAN], termin.teilnehmer)
		assertEquals(_stefansKalender.alleTermine, [termin])
		assertEquals(_henningsKalender.alleTermine, [termin])
	}

	void testTeilnehmerKoennenTermineZuUndAbsagen() {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo")
		termin.ladeTeilnehmerEin(MARTIN)
		termin.ladeTeilnehmerEin(HENNING)

		assertEquals(Teilnahme.OFFEN, termin.getTeilnahmeStatus(MARTIN))

		termin.bestaetigeTermin(HENNING)
		termin.lehneTerminAb(MARTIN)

		assertEquals(Teilnahme.BESTAETIGT, termin
				.getTeilnahmeStatus(HENNING))
		assertEquals(Teilnahme.ABGELEHNT, termin
				.getTeilnahmeStatus(MARTIN))
	}

	void testAutorSagtTerminPerDefaultZu() {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo")

		assertEquals(Teilnahme.BESTAETIGT, termin.getTeilnahmeStatus(STEFAN))
	}

	void testPerDefaultKeineAbgelehntenTermineAnzeigen() {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo")
		termin.ladeTeilnehmerEin(HENNING)

		termin.lehneTerminAb(HENNING)

		Collection keineAbgelehntenTermine = _henningsKalender.alleTermine
		assertTrue(keineAbgelehntenTermine.isEmpty())
		
		Collection auchAbgelehnteTermineML = _martinsKalender.getTermine(true)
		assertEquals(0, auchAbgelehnteTermineML.size())

	}

	void testAufWunschAbgelehnteTermineAnzeigen() {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo")
		termin.ladeTeilnehmerEin(HENNING)

		termin.lehneTerminAb(HENNING)
		Collection auchAbgelehnteTermine = _henningsKalender
				.getTermine(true)
		assertEquals(1, auchAbgelehnteTermine.size())

		Collection keineAbgelehntenTermine = _henningsKalender
				.getTermine(false)
		assertTrue(keineAbgelehntenTermine.isEmpty())
	}

	void testBenutzerNichtEingeladenException() {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo")
		try {
			termin.lehneTerminAb(HENNING)
			fail("BenutzerNichtVorhandenException erwartet")
		} catch (BenutzerNichtEingeladenException e) {
			assertTrue("Exception erwartet", true)
		}
	}
	
}
