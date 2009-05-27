import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;

import junit.framework.TestCase;

public class TerminkalenderTest extends TestCase {

	private static final String STEFAN = "Stefan", HENNING = "Henning",
			MARTIN = "Martin";

	private TerminRepository _terminRepository = new TerminRepository();

	private Calendar _calendar = Calendar.getInstance();

	private Date _jetzt = _calendar.getTime();

	private Date _spaeter = new Date(_jetzt.getTime() + 10000);

	private Terminkalender _stefansKalender = new Terminkalender(
			_terminRepository, STEFAN);

	private Terminkalender _henningsKalender = new Terminkalender(
			_terminRepository, HENNING);

	private Terminkalender _martinsKalender = new Terminkalender(
			_terminRepository, MARTIN);
	
	public void testTerminAnlegen() {
		int dauerInMinuten = 180;
		Termin termin = _stefansKalender.newTermin(_jetzt, dauerInMinuten,
				"TDD-Dojo");
		assertTrue(_stefansKalender.hatTermin(termin));
		assertEquals("TDD-Dojo", termin.getBezeichnung());
		assertEquals(_jetzt, termin.getStartZeit());
		assertEquals(dauerInMinuten, termin.getDauerInMinuten());
		assertEquals(STEFAN, termin.getAutor());
	}

	public void testTerminlisteSortiertNachStartzeit() {
		Termin termin2 = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
		Termin termin3 = _stefansKalender.newTermin(_spaeter, 45, "TDD-Dojo");
		Termin termin1 = _stefansKalender.newTermin(_jetzt, 10,
				"Meeting mit Müller");

		assertEqualsCollection(_stefansKalender.getTermine(), termin1, termin2,
				termin3);
	}

	public void testTerminkalenderJeBenutzer() {
		Termin terminStefan = _stefansKalender.newTermin(_jetzt, 180,
				"TDD-Dojo");
		Termin terminHenning = _henningsKalender.newTermin(_spaeter, 60,
				"Joggen");

		assertEqualsCollection(_stefansKalender.getTermine(), terminStefan);
		assertEqualsCollection(_henningsKalender.getTermine(), terminHenning);

	}

	public void testTeilnehmerEinladenUndAutorIstAuchTeilnehmer() {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
		termin.ladeTeilnehmerEin(MARTIN);
		termin.ladeTeilnehmerEin(HENNING);

		assertEqualsCollection(termin.getTeilnehmer(), HENNING, MARTIN, STEFAN);
		assertEqualsCollection(_stefansKalender.getTermine(), termin);
		assertEqualsCollection(_henningsKalender.getTermine(), termin);
	}

	public void testTeilnehmerKoennenTermineZuUndAbsagen() throws Exception {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
		termin.ladeTeilnehmerEin(MARTIN);
		termin.ladeTeilnehmerEin(HENNING);

		assertEquals(TeilnahmeStatus.OFFEN, termin.getTeilnahmeStatus(MARTIN));

		termin.bestaetigeTermin(HENNING);
		termin.lehneTerminAb(MARTIN);

		assertEquals(TeilnahmeStatus.BESTAETIGT, termin
				.getTeilnahmeStatus(HENNING));
		assertEquals(TeilnahmeStatus.ABGELEHNT, termin
				.getTeilnahmeStatus(MARTIN));
	}

	public void testAutorSagtTerminPerDefaultZu() throws Exception {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");

		assertEquals(TeilnahmeStatus.BESTAETIGT, termin
				.getTeilnahmeStatus(STEFAN));
	}

	public void testPerDefaultKeineAbgelehntenTermineAnzeigen()
			throws Exception {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
		termin.ladeTeilnehmerEin(HENNING);

		termin.lehneTerminAb(HENNING);

		Collection<Termin> keineAbgelehntenTermine = _henningsKalender
				.getTermine();
		assertTrue(keineAbgelehntenTermine.isEmpty());
		
		Collection<Termin> auchAbgelehnteTermineML = _martinsKalender.getTermine(true);
		assertEquals(0, auchAbgelehnteTermineML.size());

	}

	public void testAufWunschAbgelehnteTermineAnzeigen() throws Exception {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
		termin.ladeTeilnehmerEin(HENNING);

		termin.lehneTerminAb(HENNING);
		Collection<Termin> auchAbgelehnteTermine = _henningsKalender
				.getTermine(true);
		assertEquals(1, auchAbgelehnteTermine.size());

		Collection<Termin> keineAbgelehntenTermine = _henningsKalender
				.getTermine(false);
		assertTrue(keineAbgelehntenTermine.isEmpty());
	}

	public void testBenutzerNichtEingeladenException() {
		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
		try {
			termin.lehneTerminAb(HENNING);
			fail("BenutzerNichtVorhandenException erwartet");
		} catch (BenutzerNichtEingeladenException e) {
			assertTrue("Exception erwartet", true);
		}

	}

	private void assertEqualsCollection(Collection actual,
			Object... expectedObjects) {
		assertEquals(expectedObjects.length, actual.size());
		Iterator actualIter = actual.iterator();
		for (Object expected : expectedObjects) {
			assertEquals(expected, actualIter.next());
		}
	}
}
