public class Teilnahme implements Comparable {

  	public static final int OFFEN = 1, BESTAETIGT = 2, ABGELEHNT = 3	

	String teilnehmer
	int status = OFFEN

	public Teilnahme(String einTeilnehmer) {
		status = OFFEN
		teilnehmer = einTeilnehmer
	}

	public Teilnahme(int status, String teilnehmer) {
		this.status = status
		this.teilnehmer = teilnehmer
	}

	public int compareTo(Object o) {
		getTeilnehmer() <=>  o.teilnehmer
	}

	public int hashCode() {
		teilnehmer.hashCode()
	}
	
	public boolean equals (Object o) {
		teilnehmer == o.teilnehmer
	}

	public void bestaetige() {
		status = BESTAETIGT
	}

	public void lehneAb() {
		status = ABGELEHNT
	}

	public boolean isAbgelehnt() {
		status == ABGELEHNT
	}

}
