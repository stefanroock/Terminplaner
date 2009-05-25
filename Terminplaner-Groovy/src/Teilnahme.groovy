public class Teilnahme implements Comparable {

  	public static final int OFFEN = 1, BESTAETIGT = 2, ABGELEHNT = 3	

	@Property String teilnehmer
	@Property int status = OFFEN

	public Teilnahme(String einTeilnehmer) {
		status = OFFEN
		teilnehmer = einTeilnehmer
	}

	public Teilnahme(int einStatus, String einTeilnehmer) {
		status = einStatus
		teilnehmer = einTeilnehmer
	}

	public int compareTo(Object o) {
		return getTeilnehmer() <=>  o.teilnehmer
	}

	public int hashCode() {
		return teilnehmer.hashCode()
	}
	
	
	public Boolean equals (Object o) {
		return teilnehmer == o.teilnehmer
	}

	public void bestaetige() {
		status = BESTAETIGT
	}

	public void lehneAb() {
		status = ABGELEHNT
	}

	public Boolean istAbgelehnt() {
		return status == ABGELEHNT
	}

}
