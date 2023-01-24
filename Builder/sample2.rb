class DesktopComputer < Computer; end

class LaptopComputer < Computer
  def initialize(motherboard = MotherBoard.new, drives = [])
    super(:lcd, motherboard, drives)
  end
end

class ComputerBuilder
  def turbo(has_turbo_cpu = true)
    @computer.motherboard.cpu = TurboCPU.new
  end

  def memory_size=(size_in_mb)
    @computer.motherboard.memory_size = size_in_mb
  end

  def computer
    raise "Not enough memory" if @computer.motherboard.memory_size < 250
    raise "Too many drives" if @computer.drives.size > 4
    hard_disc = @computer.drives.find { |drive| drive.type == :hard_disc }
    raise "No hard disk." unless hard_disc

    @computer
  end
end

class DesktopBuilder < ComputerBuilder
  def initialize
    @computer = DesktopComputer.new
  end

  def display=(display)
    @computer.display = display
  end

  def add_cd(writer = false)
    @computer.drives << Drive.new(:cd, 760, writer)
  end

  def add_dvd(writer = false)
    @computer.drives << Drive.new(:dvd, 4000, writer)
  end

  def add_hard_disc(size_in_mb)
    @computer.drives << Drive.new(:hard_disc, size_in_mb, true)
  end
end

class LaptopBuilder < ComputerBuilder
  def display=(display)
    raise "Laptop display must be lcd" unless display == :lcd
  end

  def add_cd(writer = false)
    @computer.drives << LaptopDrive.new(:cd, 760, writer)
  end

  def add_dvd(writer = false)
    @computer.drives << LaptopDrive.new(:dvd, 4000, writer)
  end

  def add_hard_disc(size_in_mb)
    @computer.drives << LaptopDrive.new(:hard_disc, size_in_mb, true)
  end
end
