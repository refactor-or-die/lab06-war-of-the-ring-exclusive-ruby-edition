# Symulator armii Srodziemia - wersja Ruby
#
# UWAGA: Ten kod ma EKSPLOZJE PETLI! Uzyj wzorca Composite.
#
# Kazda operacja (get_strength, count_units, show, get_units_by_type)
# wymaga tych samych zagniezdzonych petli. To nie jest skalowalne!

# ============================================================================
# POJEDYNCZE JEDNOSTKI
# ============================================================================

module MilitaryUnit

  def initialize(name)
    @name = name
    @units = []
  end
  def get_strength
    total = 0
    @units.each { |unit| total += unit.strength }
    total
  end

  def count_units
    total = 0
    @units.each { |unit| total += unit.count_units }
    total
  end

  def get_units_by_type(unit_type)
    result = []
    @units.each do |unit|
      result << unit.get_units_by_type(unit_type)
    end
    result
  end

  def get_strongest_unit
    return nil if @units.empty?
    strongest = @units.first.get_strongest_unit
    @units.each do |unit|
      strongest = unit.get_strongest_unit if unit.get_strongest_unit.get_strength > strongest.get_strength
    end
    strongest
  end

  def show(indent = 0)
    prefix = "  " * indent
    lines = ["#{prefix}[#{@unit_type}: #{@name}] (sila: #{get_strength}, jednostek: #{count_units})"]
    @units.each do |unit|
      lines << unit.show_strengthless(indent)
    end
    lines.join("\n")
  end

  def show_strengthless(indent = 0)
    prefix = "  " * indent
    lines = ["#{prefix}[#{@unit_type}: #{@name}]"]
    @units.each do |unit|
      lines << unit.show_strengthless(indent)
    end
    lines.join("\n")
  end
end

class Orc
  include MilitaryUnit
  attr_reader :name, :unit_type, :strength, :description

  def initialize(name)
    @name = name
    @unit_type = "Orc"
    @strength = 5
    @description = "Plugawy sluga Ciemnosci"
  end

  def get_strength
    @strength
  end

  def count_units
    1
  end

  def get_units_by_type(unit_type)
    if @unit_type == unit_type
      return [self]
    end
    []
  end

  def get_strongest_unit
    self
  end

  def show(indent = 0)
    prefix = "  " * indent
    lines = []
    lines << "#{prefix}  - #{@name} (#{@unit_type}, sila: #{@strength})"
    lines.join("\n")
  end
end

class UrukHai
  attr_reader :name, :unit_type, :strength, :description

  def initialize(name)
    @name = name
    @unit_type = "Uruk-hai"
    @strength = 12
    @description = "Doskonaly wojownik stworzony przez Sarumana"
  end

  def get_strength
    @strength
  end

  def count_units
    1
  end

  def get_units_by_type(unit_type)
    if @unit_type == unit_type
      return [self]
    end
    []
  end

  def get_strongest_unit
    self
  end

  def show(indent = 0)
    prefix = "  " * indent
    lines = []
    @units.each do |unit|
      lines << "#{prefix}  - #{@name} (#{@unit_type}, sila: #{@strength})"
    end
    lines.join("\n")
  end
end

class Troll
  attr_reader :name, :unit_type, :strength, :description

  def initialize(name)
    @name = name
    @unit_type = "Troll"
    @strength = 45
    @description = "Ogromna bestia"
  end

  def get_strength
    @strength
  end

  def count_units
    1
  end

  def get_units_by_type(unit_type)
    if @unit_type == unit_type
      return [self]
    end
    []
  end

  def get_strongest_unit
    self
  end

  def show(indent = 0)
    prefix = "  " * indent
    lines = []
    @units.each do |unit|
      lines << "#{prefix}  - #{@name} (#{@unit_type}, sila: #{@strength})"
    end
    lines.join("\n")
  end
end

class Nazgul
  attr_reader :name, :unit_type, :strength, :description

  def initialize(name)
    @name = name
    @unit_type = "Nazgul"
    @strength = 100
    @description = "Upiur Pierscienia"
  end
  def get_strength
    @strength
  end

  def count_units
    1
  end

  def get_units_by_type(unit_type)
    if @unit_type == unit_type
      return [self]
    end
    []
  end

  def get_strongest_unit
    self
  end

  def show(indent = 0)
    prefix = "  " * indent
    lines = []
    @units.each do |unit|
      lines << "#{prefix}  - #{@name} (#{@unit_type}, sila: #{@strength})"
    end
    lines.join("\n")
  end
end

class Elf
  attr_reader :name, :unit_type, :strength, :description

  def initialize(name)
    @name = name
    @unit_type = "Elf"
    @strength = 15
    @description = "Wieczny, madry i smiertelnie celny"
  end
  def get_strength
    @strength
  end

  def count_units
    1
  end

  def get_units_by_type(unit_type)
    if @unit_type == unit_type
      return [self]
    end
    []
  end

  def get_strongest_unit
    self
  end

  def show(indent = 0)
    prefix = "  " * indent
    lines = []
    @units.each do |unit|
      lines << "#{prefix}  - #{@name} (#{@unit_type}, sila: #{@strength})"
    end
    lines.join("\n")
  end
end

class Human
  attr_reader :name, :unit_type, :strength, :description

  def initialize(name)
    @name = name
    @unit_type = "Human"
    @strength = 8
    @description = "Smiertelnik broniacy swojej ziemi"
  end
  def get_strength
    @strength
  end

  def count_units
    1
  end

  def get_units_by_type(unit_type)
    if @unit_type == unit_type
      return [self]
    end
    []
  end

  def get_strongest_unit
    self
  end

  def show(indent = 0)
    prefix = "  " * indent
    lines = []
    @units.each do |unit|
      lines << "#{prefix}  - #{@name} (#{@unit_type}, sila: #{@strength})"
    end
    lines.join("\n")
  end
end

class Dwarf
  attr_reader :name, :unit_type, :strength, :description

  def initialize(name)
    @name = name
    @unit_type = "Dwarf"
    @strength = 14
    @description = "Nieustepliwy wojownik z gor"
  end
  def get_strength
    @strength
  end

  def count_units
    1
  end

  def get_units_by_type(unit_type)
    if @unit_type == unit_type
      return [self]
    end
    []
  end

  def get_strongest_unit
    self
  end

  def show(indent = 0)
    prefix = "  " * indent
    lines = []
    @units.each do |unit|
      lines << "#{prefix}  - #{@name} (#{@unit_type}, sila: #{@strength})"
    end
    lines.join("\n")
  end
end

class Wizard
  attr_reader :name, :unit_type, :strength, :description

  def initialize(name)
    @name = name
    @unit_type = "Wizard"
    @strength = 150
    @description = "Maiar w ludzkiej postaci"
  end
  def get_strength
    @strength
  end

  def count_units
    1
  end

  def get_units_by_type(unit_type)
    if @unit_type == unit_type
      return [self]
    end
    []
  end

  def get_strongest_unit
    self
  end

  def show(indent = 0)
    prefix = "  " * indent
    lines = []
    @units.each do |unit|
      lines << "#{prefix}  - #{@name} (#{@unit_type}, sila: #{@strength})"
    end
    lines.join("\n")
  end
end

# ============================================================================
# STRUKTURY GRUPUJACE - tu zaczyna sie koszmar petli!
# ============================================================================

class Squad
  attr_reader :name
  attr_accessor :units

  def initialize(name)
    @name = name
    @units = []
    @unit_type = "Oddział"
  end

  def add_unit(unit)
    @units << unit
  end
end

class Legion
  attr_reader :name
  attr_accessor :units

  def initialize(name)
    @name = name
    @units = []
    @unit_type = "Legion"
  end

  def add_squad(squad)
    @units << squad
  end
end

class Army
  attr_reader :name, :faction
  attr_accessor :legions

  def initialize(name, faction)
    @name = name
    @faction = faction
    @units = []
  end

  def add_legion(legion)
    @units << legion
  end

  def show(indent = 0)
    prefix = "  " * indent
    lines = [
      "#{prefix}=== ARMIA: #{@name} (#{@faction}) ===",
      "#{prefix}Calkowita sila: #{get_strength}",
      "#{prefix}Liczba jednostek: #{count_units}",
      "#{prefix}" + "-" * 40
    ]
    
    @units.each do |legion|
      lines << legion.show_strengthless(indent)
    end
    lines.join("\n")
  end
end

# ============================================================================
# FUNKCJE POMOCNICZE
# ============================================================================

def create_mordor_army
  # Jednostki
  orc1 = Orc.new("Grishnakh")
  orc2 = Orc.new("Shagrat")
  orc3 = Orc.new("Gorbag")
  uruk = UrukHai.new("Ugluk")
  troll = Troll.new("Rogash")
  nazgul = Nazgul.new("Witch-king of Angmar")

  # Oddzialy
  orc_squad = Squad.new("Orkowi Zwiadowcy")
  orc_squad.add_unit(orc1)
  orc_squad.add_unit(orc2)
  orc_squad.add_unit(orc3)

  elite_squad = Squad.new("Elita Mordoru")
  elite_squad.add_unit(uruk)
  elite_squad.add_unit(troll)
  elite_squad.add_unit(nazgul)

  # Legion
  mordor_legion = Legion.new("Legion Mordoru")
  mordor_legion.add_squad(orc_squad)
  mordor_legion.add_squad(elite_squad)

  # Armia
  mordor = Army.new("Armia Mordoru", "Mordor")
  mordor.add_legion(mordor_legion)
  
  mordor
end

def create_gondor_army
  # Jednostki
  faramir = Human.new("Faramir")
  boromir = Human.new("Boromir")
  legolas = Elf.new("Legolas")
  gimli = Dwarf.new("Gimli")
  gandalf = Wizard.new("Gandalf Bialy")
  pippin = Human.new("Pippin")  # Easter egg: Hobbit jako Human :)

  # Oddzialy
  rangers = Squad.new("Strazicy Ithilien")
  rangers.add_unit(faramir)
  rangers.add_unit(boromir)

  fellowship = Squad.new("Pozostalosci Druzyny")
  fellowship.add_unit(legolas)
  fellowship.add_unit(gimli)
  fellowship.add_unit(gandalf)
  fellowship.add_unit(pippin)

  # Legion
  gondor_legion = Legion.new("Legion Gondoru")
  gondor_legion.add_squad(rangers)
  gondor_legion.add_squad(fellowship)

  # Armia
  gondor = Army.new("Armia Gondoru", "Gondor")
  gondor.add_legion(gondor_legion)
  
  gondor
end

def compare_forces(army1, army2)
  strength1 = army1.get_strength
  strength2 = army2.get_strength
  
  if strength1 > strength2
    stronger = army1.name
    difference = strength1 - strength2
  elsif strength2 > strength1
    stronger = army2.name
    difference = strength2 - strength1
  else
    stronger = "Remis"
    difference = 0
  end
  
  {
    "army1_name" => army1.name,
    "army1_strength" => strength1,
    "army1_units" => army1.count_units,
    "army2_name" => army2.name,
    "army2_strength" => strength2,
    "army2_units" => army2.count_units,
    "stronger" => stronger,
    "difference" => difference
  }
end

def merge_armies(army1, army2, new_name)
  merged = Army.new(new_name, "Sojusz")
  
  army1.legions.each { |legion| merged.add_legion(legion) }
  army2.legions.each { |legion| merged.add_legion(legion) }
  
  merged
end

# ============================================================================
# DEMO
# ============================================================================

if __FILE__ == $0
  puts "=" * 60
  puts "SYMULATOR ARMII SRODZIEMIA (Ruby Edition)"
  puts "=" * 60

  mordor = create_mordor_army
  gondor = create_gondor_army

  puts "\n#{mordor.show}"
  puts "\n#{gondor.show}"

  puts "\n" + "=" * 60
  puts "POROWNANIE SIL"
  puts "=" * 60
  
  result = compare_forces(mordor, gondor)
  puts "\n#{result['army1_name']}: sila #{result['army1_strength']}, jednostek #{result['army1_units']}"
  puts "#{result['army2_name']}: sila #{result['army2_strength']}, jednostek #{result['army2_units']}"
  puts "\nSilniejsza armia: #{result['stronger']} (o #{result['difference']})"
  
  puts "\n" + "=" * 60
  puts "NAJSILNIEJSZE JEDNOSTKI"
  puts "=" * 60
  
  mordor_strongest = mordor.get_strongest_unit
  gondor_strongest = gondor.get_strongest_unit
  
  puts "\nMordor: #{mordor_strongest.name} (#{mordor_strongest.unit_type}, sila: #{mordor_strongest.strength})"
  puts "Gondor: #{gondor_strongest.name} (#{gondor_strongest.unit_type}, sila: #{gondor_strongest.strength})"
  
  puts "\n" + "=" * 60
  puts "POLACZONE SILY (Sojusz?!)"
  puts "=" * 60
  
  merged = merge_armies(mordor, gondor, "Dziwny Sojusz")
  puts "\n#{merged.name}: sila #{merged.get_strength}, jednostek #{merged.count_units}"
end