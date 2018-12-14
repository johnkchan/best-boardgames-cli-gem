class Boardgame

    attr_accessor :name, :url, :id, :description, :price, :ages, :players, :play_time, :mechanics

    @@all = []

    def initialize(bg_hash)
        bg_hash.each {|key, value| self.send("#{key}=",value)}
        @@all << self
    end

    def self.create_from_collection(boardgame_array)
        boardgame_array.each{|boardgame_info| Boardgame.new(boardgame_info)}
    end

    def add_boardgame_attributes(attributes_hash)
        attributes_hash.each {|key, value| self.send("#{key}=", value)}
    end

    def self.all
        @@all
    end

end