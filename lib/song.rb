#######################################################################
class Song
  extend Concerns::Findable
  attr_accessor :name,:artist,:genre
  attr_reader :artist,:genre
  @@all=[]
  def initialize(name,artist="",genre="")
    @name=name
    self.artist=artist
    self.genre=genre
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
    # puts name
    song=self.new(name)
    song.save
    song
  end
  def artist=(a)
    if a != ""
      @artist = a
      artist.add_song(self)
    else
      @artist = ""
    end
  end
  def genre=(a)
    if a != ""
      @genre = a
      genre.add_song(self)
    else
      @genre = ""
    end
  end
  def self.new_from_filename(file)
    # puts file
    song_info = file.chomp(".mp3").split(" - ")
    song = Song.new(song_info[1])
    artist = Artist.find_or_create_by_name(song_info[0])
    genre = Genre.find_or_create_by_name(song_info[2])
    song.artist=artist
    song.genre=genre
    # artist.add_song(self)
    song.save
    song
  end
  def self.create_from_filename(file)
    # puts file
    self.new_from_filename(file)
  end
end

