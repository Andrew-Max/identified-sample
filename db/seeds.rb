Skip to content
 This repository
Explore
Gist
Blog
Help
@Andrew-Max Andrew-Max

 Unwatch 1
  Star 0
 Fork 0Andrew-Max/identified-sample
 tree: 8d4dc358ac  identified-sample/db/seeds.rb
@yottaflopsyottaflops an hour ago initial code cleanup and gem setup
1 contributor
RawBlameHistory    54 lines (51 sloc)  1.876 kb
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def make_items(style,color,sizes: { 'M' => 10, 'S' => 5, 'L' => 10 })
  sizes.each do |size,count|
    count.times do
      Item.create(color: color, size: size, status: 'sellable', style: style)
    end
  end
end

Style.create(name: "Cardigan 1",
             type: "Sweater",  wholesale_price: 10, retail_price: 60).tap { |style|
  make_items(style,"Purple")
  make_items(style,"Blue")
}
Style.create(name: "Cardigan 2",
             type: "Sweater",  wholesale_price: 15, retail_price: 60).tap { |style|
  make_items(style,"Red")
  make_items(style,"Blue")
}
Style.create(name: "Blouse",
             type: "Top",      wholesale_price: 13, retail_price: 45).tap { |style|
  make_items(style,"White")
}
Style.create(name: "Dress 1",
             type: "Dress",    wholesale_price: 18, retail_price: 80).tap { |style|
  make_items(style,"Orange")
  make_items(style,"Green")
}
Style.create(name: "Dress 2",
             type: "Dress",    wholesale_price: 6, retail_price: 80).tap { |style|
  make_items(style,"Orange")
  make_items(style,"Green")
}
Style.create(name: "Jeans 1",
             type: "Pants",    wholesale_price: 34, retail_price: 90).tap { |style|
  make_items(style,"Navy")
  make_items(style,"Black")
}
Style.create(name: "Scarf",
             type: "Scarf",    wholesale_price: 2, retail_price: 30).tap { |style|
  make_items(style,"Turquoise", sizes: { 'ANY' => 20 })
}
Style.create(name: "Jeans 2",
             type: "Pants",    wholesale_price: 5, retail_price: 70).tap { |style|
  make_items(style,"Navy")
}
Status API Training Shop Blog About
© 2015 GitHub, Inc. Terms Privacy Security Contact
