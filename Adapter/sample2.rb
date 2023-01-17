class Renderer
  def reader(text_object)
    text = text_object.text
    size = text_object.size_inches
    color = text_object.color

    # 文字列を表示する処理
  end
end

class TextObject
  attr_reader :text, :size_inches, :color

  def initialize(text, size_inches, color)
    @text, @size_inches, @color = text, size_inches, color
  end
end

class BritishTextObject
  attr_reader :string, :size_mm, :colour

  # ...
end

class BritishTextObjectAdapter < TextObject
  def initialize(bto)
    @bto = bto
  end

  def text
    @bto.string
  end

  def size_inches
    @bto.size_mm / 25.4
  end

  def color
    @bto.colour
  end
end
