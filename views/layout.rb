class VitriousApp
  module Views
    class Layout < Mustache
      def title 
        @title || "Vitrious the real transparent web portfolio"
      end
      
      def collections
        @collections
      end
    end
  end
end