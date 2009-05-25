public class TerminkalenderMain {

	static final String STEFAN = "Stefan";

	static TerminRepository _terminRepository = new TerminRepository()

	static Calendar _calendar = Calendar.instance

	static Date _jetzt = _calendar.time

	static Date _spaeter = new Date(_jetzt.time + 10000)

	static Terminkalender _stefansKalender = new Terminkalender(
			_terminRepository, STEFAN)

	public static void main(String[] args) {
		int dauerInMinuten = 180
		Termin termin = _stefansKalender.newTermin(_jetzt, dauerInMinuten,
				"TDD-Dojo")
		println "Termin $termin.bezeichnung am/um $termin.startZeit von $termin.autor"
	}

}
