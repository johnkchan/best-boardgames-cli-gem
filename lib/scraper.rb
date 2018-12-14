require 'nokogiri'
require 'open-uri'

class Scraper

  #  Scrape Main Page for Top 50 Boardgames
  def self.scrape_top_50
    bg_hashes = []
    doc = Nokogiri::HTML(open("https://boardgames.com/collections/fun-board-games"))
    doc.css(".grid-view-item__link").each_with_index do |boardgame, index|
      bg_hashes << {
        :name => boardgame.css(".grid-view-item__image").attribute("alt").to_s,
        :url => "https://boardgames.com/" + boardgame.attribute("href").to_s,
        :id => index + 1
      }
    end
    bg_hashes
  end

  # Scrape Details for Specific Boardgame
  def self.scrape_boardgame_attributes(boardgame_url)
    doc = Nokogiri::HTML(open(boardgame_url))
    attributes = {
      :description => doc.css(".inner").text.strip,
      :price => doc.css("span#ProductPrice-product-template").text.strip,
      :ages => doc.css(".infoTbl").css("td")[0].text.strip,
      :players => doc.css(".infoTbl").css("td")[1].text.strip,
      :play_time => doc.css(".infoTbl").css("td")[2].text.strip,
      :mechanics => doc.css(".infoTbl").css("td")[5].text.strip
    }
    attributes
  end

end