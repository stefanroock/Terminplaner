public class TerminkalenderTest extends GroovyTestCase {

	private static final String STEFAN = "Stefan", HENNING = "Henning", MARTIN = "Martin"

	Date jetzt = new Date()
	Date spaeter = new Date(jetzt.time + 10000)

	TerminRepository terminRepository = new TerminRepository()
	Terminkalender stefansKalender = new Terminkalender(terminRepository, STEFAN)
	Terminkalender henningsKalender = new Terminkalender(terminRepository, HENNING)
	Terminkalender martinsKalender = new Terminkalender(terminRepository, MARTIN)
	
	void testTerminAnlegen() {
		int dauerInMinuten = 180
		Termin termin = stefansKalender.newTermin(jetzt, dauerInMinuten, "TDD-Dojo")
		assertTrue stefansKalender.hatTermin(termin)
		assertEquals "TDD-Dojo", termin.bezeichnung
		assertEquals jetzt, termin.startZeit
		assertEquals dauerInMinuten, termin.dauerInMinuten
		assertEquals STEFAN, termin.autor
	}

	void testTerminlisteSortiertNachStartzeit() {
		Termin termin2 = stefansKalender.newTermin(jetzt, 180, "TDD-Dojo")
		Termin termin3 = stefansKalender.newTermin(spaeter, 45, "TDD-Dojo")
		Termin termin1 = stefansKalender.newTermin(jetzt, 10, "Meeting mit Müller")

		assertEquals([termin1, termin2, termin3], stefansKalender.alleTermine)
	}

	void testTerminkalenderJeBenutzer() {
		Termin terminStefan = stefansKalender.newTermin(jetzt, 180, "TDD-Dojo")
		Termin terminHenning = henningsKalender.newTermin(spaeter, 60, "Joggen")

		assertEquals([terminStefan], stefansKalender.alleTermine)
		assertEquals([terminHenning], henningsKalender.alleTermine)
	}

	void testTeilnehmerEinladenUndAutorIstAuchTeilnehmer() {
		Termin termin = stefansKalender.newTermin(jetzt, 180, "TDD-Dojo")
		termin.ladeTeilnehmerEin(MARTIN)
		termin.ladeTeilnehmerEin(HENNING)

		assertEquals([HENNING, MARTIN, STEFAN], termin.teilnehmer)
		assertEquals(stefansKalender.alleTermine, [termin])
		assertEquals(henningsKalender.alleTermine, [termin])
	}

	void testTeilnehmerKoennenTermineZuUndAbsagen() {
		Termin termin = stefansKalender.newTermin(jetzt, 180, "TDD-Dojo")
		termin.ladeTeilnehmerEin MARTIN
		termin.ladeTeilnehmerEin HENNING

		assertEquals Teilnahme.OFFEN, termin.getTeilnahmeStatus(MARTIN)

		termin.bestaetigeTermin HENNING
		termin.lehneTerminAb MARTIN

		assertEquals Teilnahme.BESTAETIGT, termin.getTeilnahmeStatus(HENNING)
		assertEquals Teilnahme.ABGELEHNT, termin.getTeilnahmeStatus(MARTIN)
	}

	void testAutorSagtTerminPerDefaultZu() {
		Termin termin = stefansKalender.newTermin(jetzt, 180, "TDD-Dojo")

		assertEquals Teilnahme.BESTAETIGT, termin.getTeilnahmeStatus(STEFAN)
	}

	void testPerDefaultKeineAbgelehntenTermineAnzeigen() {
		Termin termin = stefansKalender.newTermin(jetzt, 180, "TDD-Dojo")
		termin.ladeTeilnehmerEin HENNING

		termin.lehneTerminAb HENNING 

		Collection keineAbgelehntenTermine = henningsKalender.alleTermine
		assertTrue keineAbgelehntenTermine.empty
		
		Collection auchAbgelehnteTermineML = martinsKalender.getTermine(true)
		assertEquals 0, auchAbgelehnteTermineML.size
	}

	void testAufWunschAbgelehnteTermineAnzeigen() {
		Termin termin = stefansKalender.newTermin(jetzt, 180, "TDD-Dojo")
		termin.ladeTeilnehmerEin HENNING

		termin.lehneTerminAb HENNING
		Collection auchAbgelehnteTermine = henningsKalender.getTermine(true)
		assertEquals 1, auchAbgelehnteTermine.size

		Collection keineAbgelehntenTermine = henningsKalender.getTermine(false)
		assertTrue keineAbgelehntenTermine.empty
	}

	void testBenutzerNichtEingeladenException() {
		Termin termin = stefansKalender.newTermin(jetzt, 180, "TDD-Dojo")
		try {
			termin.lehneTerminAb HENNING
			fail("BenutzerNichtVorhandenException erwartet")
		} catch (BenutzerNichtEingeladenException e) {
			assertTrue "Exception erwartet", true
		}
	}
	
}
