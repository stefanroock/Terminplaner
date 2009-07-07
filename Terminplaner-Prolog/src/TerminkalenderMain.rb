#!/usr/bin/env ruby

require "Terminkalender"
require "TerminRepository"

STEFAN = "Stefan";
termin_repository = TerminRepository.new

jetzt = Time.new

spaeter = jetzt + 10000

stefans_kalender = Terminkalender.new(termin_repository, STEFAN)

dauer_in_minuten = 180
termin = stefans_kalender.new_termin(jetzt, dauer_in_minuten, "TDD-Dojo")
p "Termin #{termin.bezeichnung} am/um #{termin.start_zeit} von #{termin.autor}"

