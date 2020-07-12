#######################################################################
class Artist
  extend Concerns::Findable
  attr_accessor :name
  @@all=[]
  def initialize(name="")
    @name=name
    save
    @songs=[]
    # binding.pry if name !="" 
  end
  def self.all
    @@all
  end
  def self.destroy_all
    @@all.clear
  end
  def save
    @@all << self
  end
  def self.create(name)
    self.new(name)
  end
  def songs
    @songs
  end
  def add_song(song)
    song.artist=self if song.artist==""
    @songs << song if !@songs.include?(song)
  end
  def genres
    Genre.all
  end
end

