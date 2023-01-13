require 'observer'

class Employee
  include Observable

  attr_reader :name, :address
  attr_accessor :salary

  def initialize(name, title, salary)
    @name, @address, @salary = name, title, salary
  end

  def salary=(new_salary)
    @salary = new_salary
    changed
    notify_observers
  end
end
