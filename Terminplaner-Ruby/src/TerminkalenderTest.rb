#!/usr/bin/env ruby

require "runit/testcase"
require "runit/cui/testrunner"
require "runit/testsuite"
require "Terminkalender"
require "TerminRepository"
require "BenutzerNichtEingeladenException"

class TerminkalenderTest < RUNIT::TestCase

	@@STEFAN = "Stefan"
	@@HENNING = "Henning"
	@@MARTIN = "Martin"

	def setup
		@terminRepository = TerminRepository.new
		@jetzt = Time.new
		@spaeter = @jetzt + 10000
		@stefans_kalender = Terminkalender.new(@terminRepository, @@STEFAN)
		@hennings_kalender = Terminkalender.new(@terminRepository, @@HENNING)
		@martins_kalender = Terminkalender.new(@terminRepository, @@MARTIN)
	end
	
	def test_termin_anlegen
		dauer_in_minuten = 180
		termin = @stefans_kalender.new_termin(@jetzt, dauer_in_minuten, "TDD-Dojo")
		assert @stefans_kalender.hat_termin(termin)
		assert_equal("TDD-Dojo", termin.bezeichnung)
		assert_equal(@jetzt, termin.start_zeit)
		assert_equal(dauer_in_minuten, termin.dauer_in_minuten)
		assert_equal(@@STEFAN, termin.autor)
	end

	def test_terminliste_sortiert_nach_startzeit
		termin2 = @stefans_kalender.new_termin(@jetzt, 180, "TDD-Dojo")
		termin3 = @stefans_kalender.new_termin(@spaeter, 45, "TDD-Dojo")
		termin1 = @stefans_kalender.new_termin(@jetzt, 10, "Meeting mit Müller")

		assert_equal([termin1, termin2, termin3], @stefans_kalender.alle_termine)
	end

	def test_terminkalender_je_benutzer
		termin_stefan = @stefans_kalender.new_termin(@jetzt, 180, "TDD-Dojo")
		termin_henning = @hennings_kalender.new_termin(@spaeter, 60, "Joggen")

		assert_equal([termin_stefan], @stefans_kalender.alle_termine)
		assert_equal([termin_henning], @hennings_kalender.alle_termine)
	end

	def test_teilnehmer_einladen_und_autor_ist_auch_teilnehmer
		termin = @stefans_kalender.new_termin(@jetzt, 180, "TDD-Dojo")
		termin.lade_teilnehmer_ein(@@MARTIN)
		termin.lade_teilnehmer_ein(@@HENNING)

		assert_equal([@@HENNING, @@MARTIN, @@STEFAN], termin.teilnehmer)
		assert_equal(@stefans_kalender.alle_termine, [termin])
		assert_equal(@hennings_kalender.alle_termine, [termin])
	end

	def test_teilnehmer_koennen_termine_zu_und_absagen
		termin = @stefans_kalender.new_termin(@jetzt, 180, "TDD-Dojo")
		termin.lade_teilnehmer_ein(@@MARTIN)
		termin.lade_teilnehmer_ein(@@HENNING)

		assert_equal(Teilnahme.OFFEN, termin.teilnahme_status(@@MARTIN))

		termin.bestaetige_termin(@@HENNING)
		termin.lehne_termin_ab(@@MARTIN)

		assert_equal(Teilnahme.BESTAETIGT, termin.teilnahme_status(@@HENNING))
		assert_equal(Teilnahme.ABGELEHNT, termin.teilnahme_status(@@MARTIN))
	end

	def test_autor_sagt_termin_per_default_zu
		termin = @stefans_kalender.new_termin(@jetzt, 180, "TDD-Dojo")

		assert_equal(Teilnahme.BESTAETIGT, termin.teilnahme_status(@@STEFAN))
	end

	def test_per_default_keine_abgelehnten_termine_anzeigen
		termin = @stefans_kalender.new_termin(@jetzt, 180, "TDD-Dojo")
		termin.lade_teilnehmer_ein(@@HENNING)

		termin.lehne_termin_ab(@@HENNING)

		keine_abgelehnten_termine = @hennings_kalender.alle_termine
		assert(keine_abgelehnten_termine.empty?)
		
		auch_abgelehnte_termine_martin = @martins_kalender.termine(true)
		assert_equal(0, auch_abgelehnte_termine_martin.size)

	end

	def test_auf_wunsch_abgelehnte_termine_anzeigen
		termin = @stefans_kalender.new_termin(@jetzt, 180, "TDD-Dojo")
		termin.lade_teilnehmer_ein(@@HENNING)

		termin.lehne_termin_ab(@@HENNING)
		auch_abgelehnte_termine = @hennings_kalender.termine(true)
		assert_equal(1, auch_abgelehnte_termine.size)

		keine_abgelehnten_termine = @hennings_kalender.termine(false)
		assert(keine_abgelehnten_termine.empty?)
	end

	def test_benutzer_nicht_eingeladen_exception
		termin = @stefans_kalender.new_termin(@jetzt, 180, "TDD-Dojo")
		begin
			termin.lehne_termin_ab(@@HENNING)
			fail("BenutzerNichtVorhandenException erwartet")
		rescue BenutzerNichtEingeladenException
			assert("Exception erwartet", true)
		end
	end
	
end

