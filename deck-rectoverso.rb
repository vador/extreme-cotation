require 'squib'
require 'yaml'
require 'game_icons'
require 'hexapdf'

Version=1
Copyright = "version: v#{Version}"

def yaml2dataframe(yamldata)
  resultCards = Squib::DataFrame.new

  # Get keys :
  card_keys = yamldata[0].keys
  card_keys.each do |k|
    resultCards[k] = yamldata.map { |e| e[k]}
  end
  return resultCards
end

def explode_quantities(data, qty)
  new_data = Squib::DataFrame.new
  data.each do |col, arr|
    new_data[col] = []
    arr.each do |value|
      qty.to_i.times { new_data[col] << value }
    end
  end
  return new_data
end


def cutmark(top, left, right, bottom, size)
  line x1: left, y1: top, x2: left+size, y2: top, stroke_width: 1, cap: :round, stroke_color: 'white'
  line x1: left, y1: top, x2: left, y2: top+size, stroke_width: 1, cap: :round, stroke_color: 'white'

  line x1: right, y1: top, x2: right, y2: top+size, stroke_width: 1, cap: :round, stroke_color: 'white'
  line x1: right, y1: top, x2: right-size, y2: top, stroke_width: 1, cap: :round, stroke_color: 'white'

  line x1: left, y1: bottom, x2: left+size, y2: bottom, stroke_width: 1, cap: :round, stroke_color: 'white'
  line x1: left, y1: bottom, x2: left, y2: bottom-size, stroke_width: 1, cap: :round, stroke_color: 'white'

  line x1: right, y1: bottom, x2: right-size, y2: bottom, stroke_width: 1, cap: :round, stroke_color: 'white'
  line x1: right, y1: bottom, x2: right, y2: bottom-size, stroke_width: 1, cap: :round, stroke_color: 'white'
end

def save_home_made(file, rtl = false)
  cutmark 40, 40, 785, 1085, 10
  save_pdf file: file, width: "29.7cm", height: "21cm", trim: 40, gap: 0, rtl: rtl
end

def debug_grid()
  grid width: 25,  height: 25,  stroke_color: '#659ae9', stroke_width: 1.5
  grid width: 100, height: 100, stroke_color: '#659ae9', stroke_width: 4
end

def set_background()
    background color: 'black'
end

CardOrigs = YAML.load_file('data/cards.yml')
Cards2 = yaml2dataframe(CardOrigs)

cardcolors = ['metrology_color', '#CD3349', '#8F074B' ]

#cardcolors = ['leadership_color', 'collaboration_color', 'testing_color' ]
  #'agile_color', 'bizdev_partnership_color', 'continuous_delivery_color', 'code_quality_color',
  #'metrology_color']
Cards = explode_quantities(Cards2, cardcolors.size)

puts cardcolors.size
puts Cards.nrows

Squib::Deck.new(cards: Cards.nrows, layout: 'layout-animals.yml') do
  background color: 'white'
  rect layout: 'cut' # cut line as defined by TheGameCrafter

#  card_marker = ['CardA', 'CardB', 'CardC']
#  0.upto(Cards.size-1) do |n|
#    rect range: n, layout: card_marker[n % 3], fill_color: Cards2.textcolor, stroke_color: Cards2.textcolor
#  end
#cardcolors = ['agile_color', 'bizdev_partnership_color', 'continuous_delivery_color', 'metrology_color']

0.upto(Cards.nrows-1) do |n|
  rect range: n, layout: 'safe', stroke_color: cardcolors[n % cardcolors.size] # safe zone as defined by TheGameCrafter
  rect range: n, layout: 'HeaderFlatBottom', fill_color: cardcolors[n % cardcolors.size]
  rect range: n, layout: 'HeaderRound', fill_color: cardcolors[n % cardcolors.size]
end

  text str: Cards.title, layout: 'Title', color: 'light_text'

  png file: Cards.icon, layout: 'icon'

  cutmark 40, 40, 785, 1085, 10

  #save_sheet range: :all, prefix: "recto_animaux_", trim: 40, gap: 0, columns:5, rows: 2, width: "29.7cm", height: "21cm"

  save_home_made "cards-animaux.pdf"
end

## 8 cards per save_sheet
nb_backs = (((Cards.nrows-1).to_i/8) + 1) * 8

Squib::Deck.new(cards: nb_backs, layout: 'layout-animals.yml') do
  background color: 'white'
  rect layout: 'cut' # cut line as defined by TheGameCrafter
  rect layout: 'safe', stroke_color: 'agile_color' # safe zone as defined by TheGameCrafter
  #rect layout: 'HeaderFlatBottom', fill_color: 'agile_color'
  #rect layout: 'HeaderRound', fill_color: 'agile_color'

#  png file: 'icons/peaugirafe.png', layout: 'safe'
  #cardcolors = ['agile_color', 'bizdev_partnership_color', 'continuous_delivery_color', 'metrology_color']

  0.upto(Cards.nrows-1) do |n|
    rect range: n, layout: 'safe', stroke_color: cardcolors[n % cardcolors.size], fill_color: cardcolors[n % cardcolors.size] # safe zone as defined by TheGameCrafter
    #rect range: n, layout: 'HeaderFlatBottom', fill_color: cardcolors[n % cardcolors.size]
    #rect range: n, layout: 'HeaderRound', fill_color: cardcolors[n % cardcolors.size]
  end


  cutmark 40, 40, 785, 1085, 10

  #save_sheet range: :all, prefix: "verso_animaux_", trim: 40, gap: 0, columns:5, rows: 2, rtl: true, width: "29.7cm", height: "21cm"

  save_home_made "cards-back-animaux.pdf", rtl: true
end

target = HexaPDF::Document.new

page = target.pages.add
canvas = page.canvas
