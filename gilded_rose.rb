def update_quality(items)
  updater_factory = UpdaterFactory.new

  items.each {|item|
    updater_factory.make(item).update}

end

class UpdaterFactory

  def make item

    if item.name == 'Aged Brie'
      ItemUpdater.new(AgedBrieQualityUpdater.new(item), SellInUpdater.new(item))

    elsif item.name == 'Sulfuras, Hand of Ragnaros'
      ItemUpdater.new(NullUpdater.new, NullUpdater.new)

    elsif item.name == 'Backstage passes to a TAFKAL80ETC concert'
      ItemUpdater.new(BackstageQualityUpdater.new(item), SellInUpdater.new(item))

    elsif item.name == "Conjured Mana Cake"
      ItemUpdater.new(ConjuredItemQualityUpdater.new(item), SellInUpdater.new(item))

    else
      ItemUpdater.new(DefaultQualityUpdater.new(item), SellInUpdater.new(item))
    end

  end

end

class QualityUpdater

  def initialize item
    @item = item
  end

  def update quantity
    @item.quality = [50, determine_quality(quantity)].min
  end

  private

  def determine_quality(quantity)
    [0, @item.quality + quantity].max
  end

end

class SellInUpdater

  def initialize item
    @item = item
  end

  def update
    @item.sell_in -= 1
  end

end

class DefaultQualityUpdater < QualityUpdater

  def update

    if @item.sell_in < 0
      super(-2)
    else
      super(-1)
    end

  end

end

class AgedBrieQualityUpdater < QualityUpdater

  def update

    if @item.sell_in < 0
      super(2)
    else
      super(1)
    end

  end

end

class NullUpdater

  def update

  end

end

class BackstageQualityUpdater < QualityUpdater

  def update

    if @item.sell_in < 0
      super(-@item.quality)

    elsif @item.sell_in < 5
      super(3)

    elsif @item.sell_in < 10
      super(2)

    else
      super(1)
    end

  end

end

class ConjuredItemQualityUpdater < QualityUpdater

  def update


    if @item.sell_in < 0
      super(-4)
    else
      super(-2)
    end

  end

end

class ItemUpdater

  def initialize quality_updater, sell_in_updater
    @quality_updater = quality_updater
    @sell_in_updater = sell_in_updater
  end

  def update

    @sell_in_updater.update
    @quality_updater.update

  end

end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

