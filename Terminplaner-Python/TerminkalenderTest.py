import unittest
import datetime
import TerminRepository
import Terminkalender

class TerminkalenderTest(unittest.TestCase):

    __stefan = "Stefan"
    __henning = "Henning"
    __martin = "Martin"

    def testTerminAnlegen(self):
        dauerInMinuten = 180
        termin = self.__stefans_kalender.new_termin(self.__jetzt, dauerInMinuten, "TDD-Dojo")
        self.failUnless(self.__stefans_kalender.hat_termin(termin))
        self.assertEqual("TDD-Dojo", termin.bezeichnung)
        self.assertEqual(self.__jetzt, termin.startzeit)
        self.assertEqual(dauerInMinuten, termin.dauer_in_minuten)
        self.assertEqual(self.__stefan, termin.autor)
        
    def testTerminkalenderJeBenutzer(self):
        terminStefan = self.__stefans_kalender.new_termin(self.__jetzt, 180, "TDD-Dojo")
        terminHenning = self.__hennings_kalender.new_termin(self.__jetzt, 60, "Joggen")
        self.assertEqual([terminStefan], self.__stefans_kalender.akzeptierte_termine())
        self.assertEqual([terminHenning], self.__hennings_kalender.akzeptierte_termine())

    def testTerminlisteSortiertNachStartzeit(self):
        termin1 = self.__stefans_kalender.new_termin(self.__jetzt, 180, "TDD-Dojo")
        termin2 = self.__stefans_kalender.new_termin(self.__spaeter, 45, "TDD-Dojo")
        termin3 = self.__stefans_kalender.new_termin(self.__jetzt, 10, "Meeting mit M?ller")
        self.assertEqual([termin1, termin3, termin2], self.__stefans_kalender.alle_termine())

########	public void testTeilnehmerEinladenUndAutorIstAuchTeilnehmer() {
########		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
########		termin.ladeTeilnehmerEin(MARTIN);
########		termin.ladeTeilnehmerEin(HENNING);
########
########		assertEqualsCollection(termin.getTeilnehmer(), HENNING, MARTIN, STEFAN);
########		assertEqualsCollection(_stefansKalender.getTermine(), termin);
########		assertEqualsCollection(_henningsKalender.getTermine(), termin);
########	}
########
########	public void testTeilnehmerKoennenTermineZuUndAbsagen() throws Exception {
########		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
########		termin.ladeTeilnehmerEin(MARTIN);
########		termin.ladeTeilnehmerEin(HENNING);
########
########		assertEquals(TeilnahmeStatus.OFFEN, termin.getTeilnahmeStatus(MARTIN));
########
########		termin.bestaetigeTermin(HENNING);
########		termin.lehneTerminAb(MARTIN);
########
########		assertEquals(TeilnahmeStatus.BESTAETIGT, termin
########				.getTeilnahmeStatus(HENNING));
########		assertEquals(TeilnahmeStatus.ABGELEHNT, termin
########				.getTeilnahmeStatus(MARTIN));
########	}
########
########	public void testAutorSagtTerminPerDefaultZu() throws Exception {
########		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
########
########		assertEquals(TeilnahmeStatus.BESTAETIGT, termin
########				.getTeilnahmeStatus(STEFAN));
########	}
########
########	public void testPerDefaultKeineAbgelehntenTermineAnzeigen()
########			throws Exception {
########		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
########		termin.ladeTeilnehmerEin(HENNING);
########
########		termin.lehneTerminAb(HENNING);
########
########		Collection<Termin> keineAbgelehntenTermine = _henningsKalender
########				.getTermine();
########		assertTrue(keineAbgelehntenTermine.isEmpty());
########
########		Collection<Termin> auchAbgelehnteTermineML = _martinsKalender.getTermine(true);
########		assertEquals(0, auchAbgelehnteTermineML.size());
########
########	}
########
########	public void testAufWunschAbgelehnteTermineAnzeigen() throws Exception {
########		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
########		termin.ladeTeilnehmerEin(HENNING);
########
########		termin.lehneTerminAb(HENNING);
########		Collection<Termin> auchAbgelehnteTermine = _henningsKalender
########				.getTermine(true);
########		assertEquals(1, auchAbgelehnteTermine.size());
########
########		Collection<Termin> keineAbgelehntenTermine = _henningsKalender
########				.getTermine(false);
########		assertTrue(keineAbgelehntenTermine.isEmpty());
########	}
########
########	public void testBenutzerNichtEingeladenException() {
########		Termin termin = _stefansKalender.newTermin(_jetzt, 180, "TDD-Dojo");
########		try {
########			termin.lehneTerminAb(HENNING);
########			fail("BenutzerNichtVorhandenException erwartet");
########		} catch (BenutzerNichtEingeladenException e) {
########			assertTrue("Exception erwartet", true);
########		}
########
########	}

    def setUp(self):
        self.__termin_repository = TerminRepository.TerminRepository()
        self.__stefans_kalender = Terminkalender.Terminkalender(self.__termin_repository, self.__stefan)
        self.__hennings_kalender = Terminkalender.Terminkalender(self.__termin_repository, self.__henning)
        self.__martins_kalender = Terminkalender.Terminkalender(self.__termin_repository, self.__martin)
        self.__jetzt = datetime.datetime(2007, 3, 18, 10, 15)
        self.__spaeter = datetime.datetime(2007, 3, 18, 10, 16)
        
    def tearDown(self):
        pass

if __name__ == '__main__':
    unittest.main()
