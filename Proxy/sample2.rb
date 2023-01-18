require 'etc'

class AccountProtectionProxy
  def initialize(real_object, owner_name)
    @subject = real_object
    @owner_name = owner_name
  end

  def deposit(amount)
    check_access
    @subject.deposit(amount)
  end

  def withdraw(amount)
    check_access
    @subject.withdraw(amount)
  end

  def balance
    check_access
    @subject.balance
  end

  private
    def check_access
      if Etc.getlogin != @owner_name
        raise "Illegal access: #{Etc.getlogin} cannot access control"
      end
    end
end
