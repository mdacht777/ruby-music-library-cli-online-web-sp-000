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


