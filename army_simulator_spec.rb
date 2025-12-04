# Testy jednostkowe dla symulatora armii Srodziemia (Ruby)
# NIE MODYFIKUJ TESTOW! Powinny przechodzic zarowno przed jak i po refaktoryzacji.
#
# Te testy sprawdzaja ZACHOWANIE, nie implementacje.
# Dzieki temu dzialaja zarowno z kodem "przed" (petle) jak i "po" (Composite).
#
# Uruchomienie: rspec army_simulator_spec.rb

require_relative 'army_simulator'

# ============================================================================
# HELPERY: uniwersalne metody dzialajace przed i po refaktoryzacji
# ============================================================================

def add_to_group(group, item)
  # Dziala z add_unit/add_squad/add_legion/add
  if group.respond_to?(:add_unit)
    group.add_unit(item)
  elsif group.respond_to?(:add_squad)
    group.add_squad(item)
  elsif group.respond_to?(:add_legion)
    group.add_legion(item)
  elsif group.respond_to?(:add)
    group.add(item)
  else
    raise "Don't know how to add to #{group.class}"
  end
end

def get_strength(unit)
  # Dziala z atrybutem lub metoda
  if unit.respond_to?(:get_strength)
    unit.get_strength
  elsif unit.respond_to?(:strength) && unit.method(:strength).arity == 0
    # Metoda strength() lub atrybut strength
    unit.strength
  else
    raise "Don't know how to get strength from #{unit.class}"
  end
end

def get_unit_count(group)
  # Dziala z count_units() lub count()
  if group.respond_to?(:count_units)
    group.count_units
  elsif group.respond_to?(:count)
    group.count
  else
    raise "Don't know how to count #{group.class}"
  end
end

# ============================================================================
# TESTY POJEDYNCZYCH JEDNOSTEK
# ============================================================================

RSpec.describe 'Individual Units' do
  describe Orc do
    it 'has correct stats' do
      orc = Orc.new("Grishnakh")
      expect(orc.name).to eq("Grishnakh")
      expect(orc.unit_type).to eq("Orc")
      expect(get_strength(orc)).to eq(5)
    end
  end

  describe UrukHai do
    it 'is stronger than orc' do
      orc = Orc.new("Weakling")
      uruk = UrukHai.new("Lurtz")
      expect(get_strength(uruk)).to be > get_strength(orc)
    end
  end

  describe Troll do
    it 'has high strength' do
      troll = Troll.new("Mountain Troll")
      expect(get_strength(troll)).to be >= 40
    end
  end

  describe Nazgul do
    it 'is powerful' do
      nazgul = Nazgul.new("Witch-king")
      expect(get_strength(nazgul)).to be >= 100
    end
  end

  describe Elf do
    it 'has correct attributes' do
      elf = Elf.new("Legolas")
      expect(elf.unit_type).to eq("Elf")
      expect(get_strength(elf)).to be > 0
    end
  end

  describe Human do
    it 'has correct attributes' do
      human = Human.new("Aragorn")
      expect(human.unit_type).to eq("Human")
      expect(get_strength(human)).to be > 0
    end
  end

  describe Dwarf do
    it 'has correct attributes' do
      dwarf = Dwarf.new("Gimli")
      expect(dwarf.unit_type).to eq("Dwarf")
      expect(get_strength(dwarf)).to be > 0
    end
  end

  describe Wizard do
    it 'is most powerful' do
      wizard = Wizard.new("Gandalf")
      troll = Troll.new("Cave Troll")
      nazgul = Nazgul.new("Ringwraith")
      expect(get_strength(wizard)).to be > get_strength(troll)
      expect(get_strength(wizard)).to be > get_strength(nazgul)
    end
  end
end

# ============================================================================
# TESTY ODDZIALOW (SQUAD)
# ============================================================================

RSpec.describe Squad do
  describe 'empty squad' do
    it 'has zero strength' do
      squad = Squad.new("Empty Squad")
      expect(squad.get_strength).to eq(0)
    end

    it 'has zero units' do
      squad = Squad.new("Empty Squad")
      expect(get_unit_count(squad)).to eq(0)
    end
  end

  describe 'squad with units' do
    it 'counts one unit correctly' do
      squad = Squad.new("Solo")
      orc = Orc.new("Lonely Orc")
      add_to_group(squad, orc)
      expect(get_unit_count(squad)).to eq(1)
      expect(squad.get_strength).to eq(5)
    end

    it 'sums strength of all units' do
      squad = Squad.new("Mixed Squad")
      add_to_group(squad, Orc.new("Orc1"))      # 5
      add_to_group(squad, Orc.new("Orc2"))      # 5
      add_to_group(squad, UrukHai.new("Uruk"))  # 12
      expect(squad.get_strength).to eq(22)
    end

    it 'counts all units' do
      squad = Squad.new("Big Squad")
      5.times { |i| add_to_group(squad, Orc.new("Orc#{i}")) }
      expect(get_unit_count(squad)).to eq(5)
    end
  end

  describe '#show' do
    it 'contains squad and unit names' do
      squad = Squad.new("Elite Warriors")
      add_to_group(squad, UrukHai.new("Lurtz"))
      output = squad.show
      expect(output).to include("Elite Warriors")
      expect(output).to include("Lurtz")
    end
  end
end

# ============================================================================
# TESTY LEGIONOW
# ============================================================================

RSpec.describe Legion do
  describe 'empty legion' do
    it 'has zero strength' do
      legion = Legion.new("Empty Legion")
      expect(legion.get_strength).to eq(0)
    end

    it 'has zero units' do
      legion = Legion.new("Empty Legion")
      expect(get_unit_count(legion)).to eq(0)
    end
  end

  describe 'legion with squads' do
    it 'works with one squad' do
      legion = Legion.new("Small Legion")
      squad = Squad.new("Squad")
      add_to_group(squad, Orc.new("Orc"))
      add_to_group(squad, Orc.new("Orc2"))
      add_to_group(legion, squad)
      expect(get_unit_count(legion)).to eq(2)
      expect(legion.get_strength).to eq(10)
    end

    it 'works with multiple squads' do
      legion = Legion.new("Big Legion")
      
      squad1 = Squad.new("Squad 1")
      add_to_group(squad1, Orc.new("Orc"))  # 5
      
      squad2 = Squad.new("Squad 2")
      add_to_group(squad2, Troll.new("Troll"))  # 45
      
      add_to_group(legion, squad1)
      add_to_group(legion, squad2)
      
      expect(get_unit_count(legion)).to eq(2)
      expect(legion.get_strength).to eq(50)
    end
  end

  describe '#show' do
    it 'contains legion and squad info' do
      legion = Legion.new("Mordor Legion")
      squad = Squad.new("Orc Raiders")
      add_to_group(squad, Orc.new("Gorbag"))
      add_to_group(legion, squad)
      
      output = legion.show
      expect(output).to include("Mordor Legion")
      expect(output).to include("Orc Raiders")
    end
  end
end

# ============================================================================
# TESTY ARMII
# ============================================================================

RSpec.describe Army do
  describe 'empty army' do
    it 'has zero strength' do
      army = Army.new("Empty", "Neutral")
      expect(army.get_strength).to eq(0)
    end

    it 'has zero units' do
      army = Army.new("Empty", "Neutral")
      expect(get_unit_count(army)).to eq(0)
    end
  end

  describe 'army with legions' do
    it 'works with one legion' do
      army = Army.new("Small Army", "Test")
      legion = Legion.new("Legion")
      squad = Squad.new("Squad")
      add_to_group(squad, Human.new("Soldier"))
      add_to_group(legion, squad)
      add_to_group(army, legion)
      
      expect(get_unit_count(army)).to eq(1)
    end

    it 'sums strength of all units' do
      army = Army.new("Test Army", "Test")
      
      legion1 = Legion.new("Legion 1")
      squad1 = Squad.new("Squad 1")
      add_to_group(squad1, Orc.new("O1"))  # 5
      add_to_group(squad1, Orc.new("O2"))  # 5
      add_to_group(legion1, squad1)
      
      legion2 = Legion.new("Legion 2")
      squad2 = Squad.new("Squad 2")
      add_to_group(squad2, Troll.new("T1"))  # 45
      add_to_group(legion2, squad2)
      
      add_to_group(army, legion1)
      add_to_group(army, legion2)
      
      expect(army.get_strength).to eq(55)
      expect(get_unit_count(army)).to eq(3)
    end
  end

  describe '#show' do
    it 'contains all hierarchical info' do
      army = Army.new("Gondor Forces", "Gondor")
      legion = Legion.new("White Tower Legion")
      squad = Squad.new("Tower Guards")
      add_to_group(squad, Human.new("Beregond"))
      add_to_group(legion, squad)
      add_to_group(army, legion)
      
      output = army.show
      expect(output).to include("Gondor Forces")
      expect(output).to include("Gondor")
      expect(output).to include("White Tower Legion")
      expect(output).to include("Tower Guards")
      expect(output).to include("Beregond")
    end
  end

  describe '#get_units_by_type' do
    it 'finds units of specific type' do
      army = Army.new("Mixed Army", "Alliance")
      legion = Legion.new("Legion")
      squad = Squad.new("Squad")
      add_to_group(squad, Orc.new("O1"))
      add_to_group(squad, Orc.new("O2"))
      add_to_group(squad, Elf.new("E1"))
      add_to_group(squad, Human.new("H1"))
      add_to_group(legion, squad)
      add_to_group(army, legion)
      
      orcs = army.get_units_by_type("Orc")
      elves = army.get_units_by_type("Elf")
      dwarves = army.get_units_by_type("Dwarf")
      
      expect(orcs.length).to eq(2)
      expect(elves.length).to eq(1)
      expect(dwarves.length).to eq(0)
    end
  end

  describe '#get_strongest_unit' do
    it 'finds the strongest unit' do
      army = Army.new("Test", "Test")
      legion = Legion.new("Legion")
      squad = Squad.new("Squad")
      add_to_group(squad, Orc.new("Weak"))
      add_to_group(squad, Wizard.new("Gandalf"))
      add_to_group(squad, Troll.new("Medium"))
      add_to_group(legion, squad)
      add_to_group(army, legion)
      
      strongest = army.get_strongest_unit
      expect(strongest.name).to eq("Gandalf")
    end
  end
end

# ============================================================================
# TESTY PREDEFINIOWANYCH ARMII
# ============================================================================

RSpec.describe 'Predefined Armies' do
  describe 'create_mordor_army' do
    it 'creates Mordor army' do
      mordor = create_mordor_army
      expect(mordor).not_to be_nil
      expect(mordor.faction).to eq("Mordor")
    end

    it 'has units' do
      mordor = create_mordor_army
      expect(get_unit_count(mordor)).to be > 0
    end

    it 'has strength' do
      mordor = create_mordor_army
      expect(mordor.get_strength).to be > 0
    end

    it 'has Nazgul' do
      mordor = create_mordor_army
      nazgul = mordor.get_units_by_type("Nazgul")
      expect(nazgul.length).to be >= 1
    end
  end

  describe 'create_gondor_army' do
    it 'creates Gondor army' do
      gondor = create_gondor_army
      expect(gondor).not_to be_nil
      expect(gondor.faction).to eq("Gondor")
    end

    it 'has units' do
      gondor = create_gondor_army
      expect(get_unit_count(gondor)).to be > 0
    end

    it 'has Gandalf' do
      gondor = create_gondor_army
      wizards = gondor.get_units_by_type("Wizard")
      expect(wizards.length).to be >= 1
      expect(wizards.any? { |w| w.name.include?("Gandalf") }).to be true
    end
  end
end

# ============================================================================
# TESTY POROWNYWANIA ARMII
# ============================================================================

RSpec.describe 'compare_forces' do
  it 'returns a hash' do
    army1 = Army.new("A1", "F1")
    army2 = Army.new("A2", "F2")
    result = compare_forces(army1, army2)
    expect(result).to be_a(Hash)
  end

  it 'has required keys' do
    army1 = Army.new("A1", "F1")
    army2 = Army.new("A2", "F2")
    result = compare_forces(army1, army2)
    
    expect(result).to have_key("army1_name")
    expect(result).to have_key("army1_strength")
    expect(result).to have_key("army1_units")
    expect(result).to have_key("army2_name")
    expect(result).to have_key("army2_strength")
    expect(result).to have_key("army2_units")
    expect(result).to have_key("stronger")
    expect(result).to have_key("difference")
  end

  it 'identifies stronger army' do
    army1 = Army.new("Strong", "F1")
    legion = Legion.new("L")
    squad = Squad.new("S")
    add_to_group(squad, Wizard.new("Gandalf"))  # 150
    add_to_group(legion, squad)
    add_to_group(army1, legion)
    
    army2 = Army.new("Weak", "F2")
    legion2 = Legion.new("L2")
    squad2 = Squad.new("S2")
    add_to_group(squad2, Orc.new("Orc"))  # 5
    add_to_group(legion2, squad2)
    add_to_group(army2, legion2)
    
    result = compare_forces(army1, army2)
    expect(result["stronger"]).to eq("Strong")
    expect(result["difference"]).to eq(145)
  end
end

# ============================================================================
# TESTY LACZENIA ARMII
# ============================================================================

RSpec.describe 'merge_armies' do
  it 'creates new army' do
    army1 = Army.new("A1", "F1")
    army2 = Army.new("A2", "F2")
    merged = merge_armies(army1, army2, "Merged")
    
    expect(merged.name).to eq("Merged")
    expect(merged).not_to eq(army1)
    expect(merged).not_to eq(army2)
  end

  it 'preserves total strength' do
    army1 = Army.new("A1", "F1")
    legion1 = Legion.new("L1")
    squad1 = Squad.new("S1")
    add_to_group(squad1, Orc.new("O1"))
    add_to_group(legion1, squad1)
    add_to_group(army1, legion1)
    
    army2 = Army.new("A2", "F2")
    legion2 = Legion.new("L2")
    squad2 = Squad.new("S2")
    add_to_group(squad2, Troll.new("T1"))
    add_to_group(legion2, squad2)
    add_to_group(army2, legion2)
    
    original_strength = army1.get_strength + army2.get_strength
    merged = merge_armies(army1, army2, "Merged")
    
    expect(merged.get_strength).to eq(original_strength)
  end
end

# ============================================================================
# TESTY GLEBOKIEJ HIERARCHII
# ============================================================================

RSpec.describe 'Deep Hierarchy' do
  it 'calculates strength through many levels' do
    army = Army.new("Deep Army", "Test")
    
    total_expected = 0
    
    3.times do |i|  # 3 legiony
      legion = Legion.new("Legion #{i}")
      4.times do |j|  # 4 oddzialy w kazdym
        squad = Squad.new("Squad #{i}-#{j}")
        5.times do |k|  # 5 orkow w kazdym
          add_to_group(squad, Orc.new("Orc #{i}-#{j}-#{k}"))
          total_expected += 5
        end
        add_to_group(legion, squad)
      end
      add_to_group(army, legion)
    end
    
    expect(army.get_strength).to eq(total_expected)
    expect(get_unit_count(army)).to eq(60)  # 3 * 4 * 5
  end

  it 'handles mixed unit types' do
    army = Army.new("Mixed", "Test")
    legion = Legion.new("Legion")
    
    squad1 = Squad.new("Orcs")
    add_to_group(squad1, Orc.new("O1"))
    add_to_group(squad1, Orc.new("O2"))
    
    squad2 = Squad.new("Elite")
    add_to_group(squad2, UrukHai.new("U1"))
    add_to_group(squad2, Troll.new("T1"))
    add_to_group(squad2, Nazgul.new("N1"))
    
    add_to_group(legion, squad1)
    add_to_group(legion, squad2)
    add_to_group(army, legion)
    
    # 5 + 5 + 12 + 45 + 100 = 167
    expect(army.get_strength).to eq(167)
    expect(get_unit_count(army)).to eq(5)
  end
end