class Tiger < CompositeBase
  member_of(:population)
  member_of(:classification)
  composite_of(:population)
end

class Jungle < CompositeBase
  composite_of(:population)
end

class Species < CompositeBase
  composite_of(:classification)
end

class Tree < CompositeBase
  member_of(:population)
  member_of(:classification)
end

class CompositeBase
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.member_of(composite_name)
    code = %Q{
      attr_accessor :parent_#{composite_name}
    }
    class_eval(code)
  end

  def self.composite_of(composite_name)
    member_of composite_name

    code = %Q{
      def sub_#{composite_name}s
        @sub_#{composite_name}s = [] unless @sub_#{composite_name}s
        @sub_#{composite_name}s
      end

      def add_sub_#{composite_name} (child)
        return if sub_#{composite_name}s.include?(child)
        sub_#{composite_name}s << child
        child.parent_#{composite_name} = self
      end

      def delete_sub_#{composite_name} (child)
        return unless sub_#{composite_name}s.include?(child)
        sub_#{composite_name}s.delete(child)
        child.parent_#{composite_name} = nil
      end
    }
    class_eval(code)
  end
end

tony_tiger = Tiger.new('tony')
se_jungle = Jungle.new('southeastern jungle tigers')
as_jungle.add_sub_population(tony_tiger)

species = Species.new('P. tigris')
species.add_sub_classification(tony_tiger)

tony_tiger.parent_classification

def member_of_composite?(obj, composite_name)
  public_methods = obj.public_methods
  public_methods.include?("parent_#{composite_name}")
end

def member_of_composite?(obj, composite_name)
  obj.respond_to?("parent_#{composite_name}")
end

