module JednostkaWojskowa
  def sila; raise NotImplementedError; end
  def liczba; raise NotImplementedError; end
  def pokaz(wciecie = 0); raise NotImplementedError; end
  def jednostki_typu(typ); raise NotImplementedError; end
  def najsilniejsza_jednostka; raise NotImplementedError; end
end


class Wojownik
  include JednostkaWojskowa

  attr_reader :name, :unit_type, :description

  def initialize(imie, typ, sila, opis = "")
    @name = imie
    @unit_type = typ
    @wartosc_sily = sila
    @description = opis
  end

  def strength
    @wartosc_sily
  end

  def sila
    @wartosc_sily
  end

  def count
    1
  end

  def liczba
    1
  end

  def pokaz(wciecie = 0)
    "  " * wciecie + "- #{@name} (#{@unit_type}, sila: #{@wartosc_sily})"
  end

  def show(wciecie = 0)
    pokaz(wciecie)
  end

  def jednostki_typu(typ)
    czy_pasuje_typ(typ) ? [self] : []
  end

  def get_units_by_type(typ)
    jednostki_typu(typ)
  end

  def najsilniejsza_jednostka
    self
  end

  def get_strongest_unit
    self
  end

  private

  def czy_pasuje_typ(typ)
    @unit_type == typ
  end
end


class GrupaJednostek
  include JednostkaWojskowa

  attr_reader :name

  def initialize(nazwa)
    @name = nazwa
    @dzieci = []
  end

  def dodaj(dziecko)
    @dzieci << dziecko
    self
  end

  def strength
    zsumuj_z_dzieci(&:strength)
  end

  def sila
    strength
  end

  def count
    zsumuj_z_dzieci(&:count)
  end

  def liczba
    count
  end

  def pokaz(wciecie = 0)
    prefiks = "  " * wciecie
    naglowek = "#{prefiks}[#{@name}] (sila: #{sila}, jednostek: #{liczba})"
    wyjscie_dzieci = @dzieci.map { |dziecko| dziecko.pokaz(wciecie + 1) }
    [naglowek, *wyjscie_dzieci].join("\n")
  end

  def show(wciecie = 0)
    pokaz(wciecie)
  end

  def jednostki_typu(typ)
    zbierz_z_dzieci { |dziecko| dziecko.jednostki_typu(typ) }
  end

  def get_units_by_type(typ)
    jednostki_typu(typ)
  end

  def najsilniejsza_jednostka
    wszyscy_najsilniejsi = @dzieci.map(&:najsilniejsza_jednostka).compact
    znajdz_najsilniejszego(wszyscy_najsilniejsi)
  end

  def get_strongest_unit
    najsilniejsza_jednostka
  end

  private

  def zsumuj_z_dzieci(&metoda)
    @dzieci.sum(&metoda)
  end

  def zbierz_z_dzieci(&blok)
    @dzieci.flat_map(&blok)
  end

  def znajdz_najsilniejszego(jednostki)
    jednostki.max_by(&:strength)
  end
end


class Orc < Wojownik
  def initialize(imie)
    super(imie, "Orc", 5, "Plugawy sluga Ciemnosci")
  end
end

class UrukHai < Wojownik
  def initialize(imie)
    super(imie, "Uruk-hai", 12, "Elitarny wojownik Sarumana")
  end
end

class Troll < Wojownik
  def initialize(imie)
    super(imie, "Troll", 45, "Ogromna bestia")
  end
end

class Nazgul < Wojownik
  def initialize(imie)
    super(imie, "Nazgul", 100, "Upiur Pierscienia")
  end
end

class Elf < Wojownik
  def initialize(imie)
    super(imie, "Elf", 15, "Niesmiertelny lucznik")
  end
end

class Human < Wojownik
  def initialize(imie)
    super(imie, "Human", 8, "Smiertelny obronca")
  end
end

class Dwarf < Wojownik
  def initialize(imie)
    super(imie, "Dwarf", 14, "Gorski wojownik")
  end
end

class Wizard < Wojownik
  def initialize(imie)
    super(imie, "Wizard", 150, "Maiar w ludzkiej postaci")
  end
end


class Squad < GrupaJednostek
  def initialize(nazwa)
    super(nazwa)
  end

  def units
    @dzieci
  end

  def add_unit(jednostka)
    dodaj(jednostka)
  end

  def add(jednostka)
    dodaj(jednostka)
  end

  def get_strength
    sila
  end

  def count_units
    liczba
  end

  def pokaz(wciecie = 0)
    prefiks = "  " * wciecie
    naglowek = "#{prefiks}[Oddzial: #{@name}] (sila: #{sila}, jednostek: #{liczba})"
    wyjscie_dzieci = @dzieci.map { |dziecko| dziecko.pokaz(wciecie + 1) }
    [naglowek, *wyjscie_dzieci].join("\n")
  end
end


class Legion < GrupaJednostek
  def initialize(nazwa)
    super(nazwa)
  end

  def squads
    @dzieci
  end

  def add_squad(oddzial)
    dodaj(oddzial)
  end

  def add(oddzial)
    dodaj(oddzial)
  end

  def get_strength
    sila
  end

  def count_units
    liczba
  end

  def pokaz(wciecie = 0)
    prefiks = "  " * wciecie
    naglowek = "#{prefiks}[Legion: #{@name}] (sila: #{sila}, jednostek: #{liczba})"
    wyjscie_dzieci = @dzieci.map { |dziecko| dziecko.pokaz(wciecie + 1) }
    [naglowek, *wyjscie_dzieci].join("\n")
  end
end


class Army < GrupaJednostek
  attr_reader :faction

  def initialize(nazwa, frakcja)
    super(nazwa)
    @faction = frakcja
  end

  def legions
    @dzieci
  end

  def add_legion(legion)
    dodaj(legion)
  end

  def add(legion)
    dodaj(legion)
  end

  def get_strength
    sila
  end

  def count_units
    liczba
  end

  def pokaz(wciecie = 0)
    prefiks = "  " * wciecie
    [
      "#{prefiks}=== ARMIA: #{@name} (#{@faction}) ===",
      "#{prefiks}Calkowita sila: #{sila}",
      "#{prefiks}Liczba jednostek: #{liczba}",
      "#{prefiks}#{'-' * 40}",
      *@dzieci.map { |dziecko| dziecko.pokaz(wciecie + 1) }
    ].join("\n")
  end
end


class BudowniczyArmii
  def self.zbuduj_armie_mordoru
    Army.new("Armia Mordoru", "Mordor").tap do |armia|
      armia.add_legion(zbuduj_legion_mordoru)
    end
  end

  def self.zbuduj_armie_gondoru
    Army.new("Armia Gondoru", "Gondor").tap do |armia|
      armia.add_legion(zbuduj_legion_gondoru)
    end
  end

  def self.zbuduj_legion_mordoru
    Legion.new("Legion Mordoru").tap do |legion|
      legion.add_squad(zbuduj_orkowych_zwiadowcow)
      legion.add_squad(zbuduj_elite_mordoru)
    end
  end

  def self.zbuduj_legion_gondoru
    Legion.new("Legion Gondoru").tap do |legion|
      legion.add_squad(zbuduj_straznikow_ithilien)
      legion.add_squad(zbuduj_pozostalosci_druzyny)
    end
  end

  def self.zbuduj_orkowych_zwiadowcow
    Squad.new("Orkowi Zwiadowcy").tap do |oddzial|
      oddzial.add_unit(Orc.new("Grishnakh"))
      oddzial.add_unit(Orc.new("Shagrat"))
      oddzial.add_unit(Orc.new("Gorbag"))
    end
  end

  def self.zbuduj_elite_mordoru
    Squad.new("Elita Mordoru").tap do |oddzial|
      oddzial.add_unit(UrukHai.new("Ugluk"))
      oddzial.add_unit(Troll.new("Rogash"))
      oddzial.add_unit(Nazgul.new("Witch-king of Angmar"))
    end
  end

  def self.zbuduj_straznikow_ithilien
    Squad.new("Strazicy Ithilien").tap do |oddzial|
      oddzial.add_unit(Human.new("Faramir"))
      oddzial.add_unit(Human.new("Boromir"))
    end
  end

  def self.zbuduj_pozostalosci_druzyny
    Squad.new("Pozostalosci Druzyny").tap do |oddzial|
      oddzial.add_unit(Elf.new("Legolas"))
      oddzial.add_unit(Dwarf.new("Gimli"))
      oddzial.add_unit(Wizard.new("Gandalf Bialy"))
      oddzial.add_unit(Human.new("Pippin"))
    end
  end
end


class OperacjeNaArmiach
  def self.porownaj(armia1, armia2)
    sila1 = armia1.get_strength
    sila2 = armia2.get_strength
    silniejszy, roznica = okresl_zwyciezce(armia1, armia2, sila1, sila2)

    {
      "army1_name" => armia1.name,
      "army1_strength" => sila1,
      "army1_units" => armia1.count_units,
      "army2_name" => armia2.name,
      "army2_strength" => sila2,
      "army2_units" => armia2.count_units,
      "stronger" => silniejszy,
      "difference" => roznica
    }
  end

  def self.polacz(armia1, armia2, nowa_nazwa)
    Army.new(nowa_nazwa, "Sojusz").tap do |polaczona|
      [armia1, armia2].each do |armia|
        armia.legions.each { |legion| polaczona.add_legion(legion) }
      end
    end
  end

  def self.okresl_zwyciezce(armia1, armia2, sila1, sila2)
    if sila1 > sila2
      [armia1.name, sila1 - sila2]
    elsif sila2 > sila1
      [armia2.name, sila2 - sila1]
    else
      ["Remis", 0]
    end
  end
end


def create_mordor_army
  BudowniczyArmii.zbuduj_armie_mordoru
end

def create_gondor_army
  BudowniczyArmii.zbuduj_armie_gondoru
end

def compare_forces(armia1, armia2)
  OperacjeNaArmiach.porownaj(armia1, armia2)
end

def merge_armies(armia1, armia2, nowa_nazwa)
  OperacjeNaArmiach.polacz(armia1, armia2, nowa_nazwa)
end


if __FILE__ == $0
  mordor = create_mordor_army
  gondor = create_gondor_army

  puts mordor.show
  puts
  puts gondor.show
  puts
  puts "=" * 50

  porownanie = compare_forces(mordor, gondor)
  puts "#{porownanie['army1_name']}: #{porownanie['army1_strength']} sily"
  puts "#{porownanie['army2_name']}: #{porownanie['army2_strength']} sily"
  puts "Zwyciezca: #{porownanie['stronger']} (+#{porownanie['difference']})"
  puts

  puts "Najsilniejszy Mordoru: #{mordor.get_strongest_unit.name}"
  puts "Najsilniejszy Gondoru: #{gondor.get_strongest_unit.name}"
  puts

  polaczona = merge_armies(mordor, gondor, "Dziwny Sojusz")
  puts "#{polaczona.name}: #{polaczona.get_strength} sily, #{polaczona.count_units} jednostek"
end