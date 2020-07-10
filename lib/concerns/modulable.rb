module Concerns
  module Findable

    def find_by_name(name)
      # binding.pry
        self.all.detect {|a| a.name==name}
    end

    def find_or_create_by_name(name)   #class method uses find/create class
#methods to detect or create instances
       if find_by_name(name)
         find_by_name(name)
       else
         create(name)
       end
    end

  end
end

