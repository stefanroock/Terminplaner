public class TerminkalenderMain {

	static final String STEFAN = "Stefan";

	static Date jetzt = new Date()
	static Date spaeter = new Date(jetzt.time + 10000)

	static TerminRepository terminRepository = new TerminRepository()
	static Terminkalender stefansKalender = new Terminkalender(terminRepository, STEFAN)

	public static void main(String[] args) {
		int dauerInMinuten = 180
		Termin termin = stefansKalender.newTermin(jetzt, dauerInMinuten,
				"TDD-Dojo")
		println "Termin $termin.bezeichnung am/um $termin.startZeit von $termin.autor"
	}

}
