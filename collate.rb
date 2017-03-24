require 'hexapdf'


Version=1
Copyright = "version: v#{Version}"

target = HexaPDF::Document.new

recto = HexaPDF::Document.open('_output/cards-animaux.pdf')
verso = HexaPDF::Document.open('_output/cards-back.pdf')

back = verso.pages[0]
#back_orig = verso.pages[0]
#back = verso.pages.add()
#canvas = back.canvas

#form = verso.add(back_orig.to_form_xobject(reference: false))
#canvas.xobject(form,at: [0,0])


recto.pages.each do |page|
                   target.pages << target.import(page)
                   target.pages << target.import(back)
                 end


#ARGV.each do |file|
#  pdf = HexaPDF::Document.open(file)
#  pdf.pages.each {|page| target.pages << target.import(page)}
#end

target.write("_output/deck-recto-verso.pdf", optimize: true)
