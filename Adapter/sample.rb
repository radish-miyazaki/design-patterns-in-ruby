class Encryptor
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0

    until reader.eof?
      clear_char = reader.getc
      encrypted_char = clear_char ^ @key[key_index]
      writer.putc(encrypted_char)
      key_index = (key_index + 1) % @key.size
    end
  end
end

class StringIOAdapter
  def initialize(string)
    @string = string
    @position = 0
  end

  def getc
    raise EOFError if eof?

    char = @string[@position]
    @position += 1
    char
  end

  def eof?
    @position >= @string.size
  end
end

reader = File.open('message.txt')
writer = File.open('message.encrypted', 'w')
encryptor = Encryptor.new('my secret key')
encryptor.encrypt(reader, writer)

encryptor = Encryptor.new('XYZZY')
reader = StringIOAdapter.new('We attack at dawn')
writer = File.open('out.txt', 'w')
encryptor.encrypt(reader, writer)
