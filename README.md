# Lab 06: War of the Ring - Exclusive Ruby Edition 💎

## Wersja Ruby z testami RSpec!

Ta wersja jest **równoważna z wersją Python** - te same testy, ta sama logika, ten sam wzorzec do zaimplementowania.

## Co zawiera repozytorium
- `army_simulator.rb` - kod z zagnieżdżonymi pętlami (do refaktoryzacji)
- `army_simulator_spec.rb` - testy RSpec (NIE RUSZAĆ!)
- Ten README

## Wymagania
- Ruby 2.7+ (sprawdź: `ruby --version`)
- RSpec (`gem install rspec`)

## Instrukcja

### 1. Uruchom kod
```bash
ruby army_simulator.rb
```

### 2. Uruchom testy (PRZED refaktoryzacją)
```bash
rspec army_simulator_spec.rb --format documentation
```

Powinno być **40 testów PASSED**

### 3. Zrefaktoryzuj używając Composite

#### Krok 1: Stwórz wspólny interfejs (module)
```ruby
module MilitaryUnit
  def strength
    raise NotImplementedError
  end
  
  def count
    raise NotImplementedError
  end
  
  def show(indent = 0)
    raise NotImplementedError
  end
end
```

#### Krok 2: Warrior (Liść)
```ruby
class Warrior
  include MilitaryUnit
  
  attr_reader :name, :unit_type, :description
  
  def initialize(name, unit_type, strength, description)
    @name = name
    @unit_type = unit_type
    @_strength = strength
    @description = description
  end
  
  def strength
    @_strength
  end
  
  def count
    1  # Lisc to zawsze 1
  end
  
  # ... itd
end
```

#### Krok 3: UnitGroup (Kompozyt)
```ruby
class UnitGroup
  include MilitaryUnit
  
  attr_reader :name
  
  def initialize(name)
    @name = name
    @children = []  # MilitaryUnit[]
  end
  
  def add(unit)
    @children << unit
  end
  
  def strength
    @children.sum(&:strength)  # Rekurencja!
  end
  
  def count
    @children.sum(&:count)  # Rekurencja!
  end
  
  # ... itd
end
```

### 4. Uruchom testy (PO refaktoryzacji)
```bash
rspec army_simulator_spec.rb --format documentation
```

Nadal **40 testów PASSED** = sukces!

## Wskazówki Ruby-specific

### Module vs Class
W Ruby interfejsy to **modules** (nie abstrakcyjne klasy jak w Pythonie):
```ruby
module MilitaryUnit
  def strength; raise NotImplementedError; end
end

class Warrior
  include MilitaryUnit  # "implementuje" interfejs
end
```

### attr_reader vs metody
`attr_reader :strength` tworzy getter, ale możesz też napisać metodę:
```ruby
# Jako atrybut
attr_reader :strength

# Jako metoda (dla Composite)
def strength
  @children.sum(&:strength)
end
```

### Idiomatyczne sumowanie
```ruby
# Zamiast petli:
total = 0
@children.each { |c| total += c.strength }

# Uzyj:
@children.sum(&:strength)

# Lub:
@children.map(&:strength).sum
```

### respond_to? dla duck typing
Testy używają helperów które sprawdzają metody dynamicznie:
```ruby
def get_strength(unit)
  if unit.respond_to?(:get_strength)
    unit.get_strength
  else
    unit.strength
  end
end
```

Dzięki temu testy działają zarówno z `get_strength` jak i `strength`.

## Różnice Python vs Ruby

| Aspekt | Python | Ruby |
|--------|--------|------|
| Interfejs | `ABC` + `@abstractmethod` | `module` + `raise NotImplementedError` |
| Getter | `@property` lub `self.x` | `attr_reader :x` |
| Suma | `sum(c.strength for c in children)` | `children.sum(&:strength)` |
| Lista | `[]` | `[]` (identycznie) |
| Pętla | `for x in list:` | `list.each { \|x\| }` |

## Struktura testów

Testy są podzielone na grupy:
- `Individual Units` - statystyki pojedynczych wojowników
- `Squad` - operacje na oddziałach
- `Legion` - operacje na legionach  
- `Army` - operacje na armiach + get_units_by_type + get_strongest_unit
- `Predefined Armies` - create_mordor_army, create_gondor_army
- `compare_forces` - porównywanie armii
- `merge_armies` - łączenie armii
- `Deep Hierarchy` - głębokie struktury (3 legiony × 4 oddziały × 5 orków)

## Kryteria oceny
- Testy RSpec przechodzą (40 testów)
- Użyty wzorzec Composite
- Brak zagnieżdżonych pętli
- Jednolity interfejs dla liści i grup
- Kod jest idiomatyczny Ruby

## FAQ

**Q: Czy muszę zachować klasy Orc, Elf itd.?**
A: Możesz je zamienić na `Warrior.new("Grishnakh", "Orc", 5, "...")` lub zachować jako subklasy/factory. Testy zadziałają w obu przypadkach.

**Q: Co z `get_strength` vs `strength`?**
A: Testy obsługują oba warianty przez helpery. Możesz użyć któregokolwiek.

**Q: Jak uruchomić tylko jeden test?**
A: `rspec army_simulator_spec.rb -e "calculates strength"`

**Q: Mogę użyć `Struct` zamiast klas?**
A: Jasne! Ruby jest elastyczny. `Warrior = Struct.new(:name, :unit_type, :strength, :description)`

---

*"Even the smallest Ruby gem can change the course of the future."* - Gandalf, prawdopodobnie

Powodzenia! 💎⚔️