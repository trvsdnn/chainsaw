Range.class_eval do

  unless method_defined?(:cover?)
    def cover?(elem)
      include?(elem)
    end
  end

end
