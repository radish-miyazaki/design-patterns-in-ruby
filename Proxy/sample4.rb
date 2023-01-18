require 'etc'

class AccountProtectionProxy
  def initialize(real_object, owner_name)
    @subject = real_object
    @owner_name = owner_name
  end

  def method_missing(symbol, *args)
    check_access
    @subject.send(symbol, *args)
  end

  private
    def check_access
      if Etc.getlogin != @owner_name
        raise "Illegal access: #{Etc.getlogin} cannot access control"
      end
    end
end

class VirtualAccountProxy
  def initialize(&block)
    @creation_block = block
  end

  def method_missing(symbol, *args)
    s = subject
    s.send(symbol, *args)
  end

  def subject
    @subject || (@subject = @creation_block.call)
  end
end
