public class Teilnahme implements Comparable {

	private final String _teilnehmer;
	private TeilnahmeStatus _status = TeilnahmeStatus.OFFEN;
	
	public Teilnahme(String teilnehmer) {
		this(TeilnahmeStatus.OFFEN, teilnehmer);
	}

	public Teilnahme(TeilnahmeStatus status, String teilnehmer) {
		_status = status;
		_teilnehmer = teilnehmer;
	}

	public String getTeilnehmer() {
		return _teilnehmer;
	}

	public int compareTo(Object o) {
		return getTeilnehmer().compareTo( ((Teilnahme)o).getTeilnehmer() );
	}

	public int hashCode() {
		return getTeilnehmer().hashCode();
	}
	
	
	public boolean equals (Object o) {
		return getTeilnehmer().equals( ((Teilnahme)o).getTeilnehmer() );
	}

	public TeilnahmeStatus getStatus() {
		return _status;
	}

	public void bestaetige() {
		_status = TeilnahmeStatus.BESTAETIGT;
	}

	public void lehneAb() {
		_status = TeilnahmeStatus.ABGELEHNT;
	}

	public boolean istAbgelehnt() {
		return _status.equals(TeilnahmeStatus.ABGELEHNT);
	}

}
