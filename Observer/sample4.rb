module Subject
  def initialize
    @observers = []
  end

  def add_observer(&observer)
    @observers << observer
  end

  def remove_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each { |observer| observer.call(self) }
  end
end

class Employee
  include Subject

  attr_reader :name, :address
  attr_accessor :salary

  def initialize(name, title, salary)
    super()
    @name, @address, @salary = name, title, salary
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end
end

fred = Employee.new('Fred', 'Crane Operator', 30000)
fred.add_observer do |changed_employee|
  puts "Cut a new check for #{changed_employee.name}"
  puts "His salary is now #{changed_employee.salary}"
end
