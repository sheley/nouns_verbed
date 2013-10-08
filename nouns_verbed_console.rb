require 'mysql2'
require 'sequel'
require 'sinatra'

DB = Sequel.connect({:adapter => 'mysql2', :user => 'root', :host => 'localhost', :database => 'nouns_verbed'})


verb_base = ARGV[0]
verb_past = ARGV[1]
noun_singular = ARGV[2]
noun_plural = ARGV[3]

DB["INSERT INTO tracked_things (verb_base, verb_past, noun_singular, noun_plural) VALUES(?, ?, ?, ?);",
	verb_base, verb_past, noun_singular, noun_plural].all
