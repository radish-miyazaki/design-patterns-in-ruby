class Employee
  attr_reader :name, :title
  attr_accessor :salary

  def initialize(name, title, salary)
    @name, @title, @salary = name, title, salary
    @observers = []
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end

  def notify_observers
    @observers.each { |observer| observer.update(self) }
  end

  def add_observer(observer)
    @observers << observer
  end

  def remove_observer(observer)
    @observers.delete(observer)
  end
end

class Payroll
  def update(changed_employee)
    puts "#{changed_employee.name}のために小切手を切ります！"
    puts "彼の給料は現在、#{changed_employee.salary}です！"
  end
end


fred = Employee.new('Radish', 'Crane Operator', 30000.0)

payroll = Payroll.new
fred.add_observer(payroll)
fred.salary = 35000