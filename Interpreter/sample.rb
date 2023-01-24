require 'find'

class Expression
  def |(other)
    Or.new(self, other)
  end

  def &(other)
    And.new(self, other)
  end

  def all
    All.new
  end

  def bigger(size)
    Bigger.new(size)
  end

  def name(pattern)
    FileName.new(pattern)
  end

  def except(expr)
    Not.new(expr)
  end

  def writable
    Writable.new
  end
end

class All < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p
    end
    results
  end
end

class FileName < Expression
  def initialize(pattern)
    @pattern = pattern
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      name = File.basename(p)
      results << p if File.fnmatch(@pattern, name)
    end
    results
  end
end

class Bigger < Expression
  def initialize(size)
    @size = size
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if File.size(p) > @size
    end
    results
  end
end

class Writable < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if File.writable?(p)
    end
    results
  end
end

class Not < Expression
  def initialize(expr)
    @expr = expr
  end

  def evaluate(dir)
    All.new.evaluate(dir) - @expr.evaluate(dir)
  end
end

class Or < Expression
  def initialize(expr1, expr2)
    @expr1 = expr1
    @expr2 = expr2
  end

  def evaluate(dir)
    result1 = @expr1.evaluate(dir)
    result2 = @expr2.evaluate(dir)
    (result1 + result2).sort.uniq
  end
end

class And < Expression
  def initialize(expr1, expr2)
    @expr1 = expr1
    @expr2 = expr2
  end

  def evaluate(dir)
    result1 = @expr1.evaluate(dir)
    result2 = @expr2.evaluate(dir)
    result1 & result2
  end
end

expr_all = All.new
files = expr_all.evaluate('test_dir')

expr_mp3 = FileName.new('*.mp3')
mp3s = expr_mp3.evaluate('test_dir')

expr_not_writable = Not.new(Writable.new)
readonly_files = expr_not_writable.evaluate('test_dir')

small_expr = Not.new(Bigger.new(1024))
small_files = small_expr.evaluate('test_dir')

not_mp3_expr = Not.new(FileName.new('*.mp3'))
not_mp3s = not_mp3_expr.evaluate('test_dir')

big_or_mp3_expr = Or.new(Bigger.new(1024), FileName.new('*.mp3'))
big_or_mp3s = big_or_mp3_expr.evaluate('test_dir')

complex_expr = And.new(And.new(Bigger.new(1024), FileName.new('*.mp3')), Not.new(Writable.new))
complex_expr.evaluate('test_dir')
complex_expr.evaluate('/tmp')

class Parser
  def initialize(text)
    @tokens = text.scan(/\(|\)|[\w\.\*]+/)
  end

  def next_token
    @tokens.shift
  end

  def expression
    token = next_token

    if token == nil
      nil

    elsif token == '('
      result = expression
      raise 'Expected )' unless next_token == ')'
      result

    elsif token == 'all'
      All.new

    elsif token == 'writable'
      Writable.new

    elsif token == 'bigger'
      Bigger.new(next_token.to_i)

    elsif token == 'filename'
      FileName.new(next_token)

    elsif token == 'not'
      Not.new(expression)

    elsif token == 'and'
      And.new(expression, expression)

    elsif token == 'or'
      Or.new(expression, expression)

    else
      raise "Unexpected token: #{token}"
    end
  end
end

parser = Parser.new "and (and(bigger 1024) (filename *.mp3)) writable"
ast = parser.expression
