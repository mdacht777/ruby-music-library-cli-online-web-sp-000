#######################################################################
class Song
  extend Concerns::Findable
  attr_accessor :name,:artist,:genre
  attr_reader :artist,:genre
  @@all=[]
  def initialize(name,artist="",genre="")
    @name=name
    # @artist=artist
    # @genre=genre
    self.artist=artist
    self.genre=genre
    save
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
  end
  def artist=(a)
    @artist=a
    # Artist.add_song(self)
    b=Artist.new(a)
    b.add_song(self)
    # save
  end
  def genre=(a)
    @genre=a
    # Genre.add_song(self)
    b=Genre.new(a)
    b.add_song(self)
    # save
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
    song
  end
  def self.create_from_filename(file)
    # puts file
    self.new_from_filename(file)
  end
end

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
    song.artist=self if song.artist==nil
    # binding.pry
    @artist=self
    @songs << song if !@songs.include?(song)
  end
  def genres
    Genre.all
  end
end

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
    # binding.pry
    song.genre=self if song.genre==""
    @songs << song if !@songs.include?(song)
  end
  def artists
    Artist.all
  end
end

#######################################################################
class MusicImporter
  attr_accessor :path
    @files=[]
  def initialize(path)
    @path=path
  end
 def files
   files = []
  # puts Dir.new(self.path)
   Dir.new(self.path).each do |file|
     files << file if (file!="." and file!="..")
   end
   files
 end
  def import
    self.files.each {|filename| Song.create_from_filename(filename)}
  end
end

#######################################################################
class MusicLibraryController
  attr_accessor :path
  def initialize(path="./db/mp3s")
    @path=path
    a=MusicImporter.new(path)
    a.import
  end

  def call
    input=""
    until input=="exit"
      puts "Welcome to your music library!"
      puts "To list all of your songs, enter 'list songs'."
      puts "To list all of the artists in your library, enter 'list artists'."
      puts "To list all of the genres in your library, enter 'list genres'."
      puts "To list all of the songs by a particular artist, enter 'list artist'."
      puts "To list all of the songs of a particular genre, enter 'list genre'."
      puts"To play a song, enter 'play song'."
      puts "To quit, type 'exit'."
      puts "What would you like to do?"
      input = gets.strip
      case input
        when "list songs"
          self.list_songs
        when "list artists"
          self.list_artists
        when "list genres"
          self.list_genres
        when "list artist"
          self.list_songs_by_artist
        when "list genre"
          self.list_songs_by_genre
        when "play song"
          self.play_song
        else
        end
    end
  end

  def list_songs
    temp=Song.all.sort_by {|obj| obj.name}
    i=1
    temp.each {|a| 
      puts "#{i}. #{a.artist.name} - #{a.name} - #{a.genre.name}"
      i+=1
      }
  end

  def list_artists
    temp=Artist.all.sort_by {|obj| obj.name}
    i=1
    temp.each {|a| 
      puts "#{i}. #{a.name}"
      i+=1
      }
  end

  def list_genres
    temp=Genre.all.sort_by {|obj| obj.name}
    i=1
    temp.each {|a| 
      puts "#{i}. #{a.name}"
      i+=1
      }
  end

  def list_songs_by_artist
    puts "Please enter the name of an artist:"
    input=gets.strip
    temp=Song.all.sort_by {|obj| obj.name}
    i=1
    temp.each {|a| 
      if a.artist.name == input
        puts "#{i}. #{a.name} - #{a.genre.name}"
        i+=1
      end
      }
  end

  def list_songs_by_genre
    puts "Please enter the name of a genre:"
    input=gets.strip
    temp=Song.all.sort_by {|obj| obj.name}
    i=1
    temp.each {|a| 
      if a.genre.name == input
        puts "#{i}. #{a.artist.name} - #{a.name}"
        i+=1
      end
      }
  end

  def play_song
    puts "Which song number would you like to play?"
    input=gets.strip.to_i
    temp=Song.all.sort_by {|obj| obj.name}
    if input>=1 and input<temp.size
      puts "Playing #{temp[input-1].name} by #{temp[input-1].artist.name}"
    end
  end

end


