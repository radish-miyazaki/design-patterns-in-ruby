module Subject
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def remove_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each { |observer| observer.update(self) }
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
