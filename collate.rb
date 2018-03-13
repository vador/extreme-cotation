require 'hexapdf'

Version=1
Copyright = "version: v#{Version}"

target = HexaPDF::Document.new

recto = HexaPDF::Document.open('_output/cards-animaux.pdf')
verso = HexaPDF::Document.open('_output/cards-back-animaux.pdf')

back = verso.pages[0]

recto.pages.size.times do |i|
  target.pages << target.import(recto.pages[i])
  target.pages << target.import(verso.pages[i])
end

target.write("_output/deck-recto-verso.pdf", optimize: true)
