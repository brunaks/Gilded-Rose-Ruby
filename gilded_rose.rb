def update_quality(items)
  updater_factory = UpdaterFactory.new

  items.each {|item|
    updater_factory.make(item).update}

end

class UpdaterFactory

  def make item

    if item.name == 'Aged Brie'
      AgedBrieUpdater.new(item)

    elsif item.name == 'Sulfuras, Hand of Ragnaros'
      SulfurasUpdater.new(item)

    elsif item.name == 'Backstage passes to a TAFKAL80ETC concert'
      BackstagePassUpdater.new(item)

    else
      DefaultUpdater.new(item)
    end

  end

end

class QualityUpdater

  def initialize item
    @item = item
  end

  def update quantity
    @item.quality = [50, @item.quality + quantity].min
  end

end

class DefaultUpdater

  def initialize item
    @item = item
  end

  def update

    item = @item

    if item.quality > 0
      item.quality -= 1
    end


    item.sell_in -= 1

    if item.sell_in < 0
      if item.quality > 0
        item.quality -= 1
      end
    end
  end

end

class BackstagePassUpdater

  def initialize item
    @item = item
  end

  def update

    item = @item

    if item.quality < 50
      item.quality += 1

      if item.sell_in < 11
        if item.quality < 50
          item.quality += 1
        end
      end
      if item.sell_in < 6

        if item.quality < 50
          item.quality += 1
        end

      end

    end

    item.sell_in -= 1

    if item.sell_in < 0

      item.quality = item.quality - item.quality

    end
  end

end


class SulfurasUpdater

  def initialize item
    @item = item
  end

  def update

  end

end

class AgedBrieUpdater

  def initialize item
    @item = item
    @quality_updater = QualityUpdater.new(item)
  end

  def update

    item = @item

    @quality_updater.update(1)

    item.sell_in -= 1

    if item.sell_in < 0

      if item.quality < 50
        item.quality += 1
      end

    end

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

