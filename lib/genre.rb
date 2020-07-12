#######################################################################
class Genre
  extend Concerns::Findable
  attr_accessor :name
  @@all=[]
  def initialize(name)
    @name=name
    save
    @songs=[]
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
    song.genre=self if song.genre==""
    @songs << song if !@songs.include?(song)
  end
  def artists
    Artist.all
  end
end

