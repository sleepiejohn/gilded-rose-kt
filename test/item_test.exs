defmodule GildedRose.ItemTest do
  use ExUnit.Case

  test "At the end of each day our system lowers both values for every item" do
    an_item = %Item{name: "Random", sell_in: 10, quality: 4}
    updated = GildedRose.update_item(an_item)
    assert updated.sell_in == 9
    assert updated.quality == 3
  end

  test "Once the sell by date has passed, Quality degrades twice as fast" do
    an_item = %Item{name: "Random", sell_in: 0, quality: 4}
    updated = GildedRose.update_item(an_item)
    assert updated.sell_in == -1
    assert updated.quality == 2
  end

  test "The Quality of an item is never negative" do
    an_item = %Item{name: "Random", sell_in: 1, quality: 0}
    updated = GildedRose.update_item(an_item)
    assert updated.sell_in == 0
    assert updated.quality == 0
  end

  test "'Aged Brie' actually increases in Quality the older it gets" do
    aged_brie = %Item{name: "Aged Brie", sell_in: 4, quality: 5}
    updated = GildedRose.update_item(aged_brie)
    assert updated.sell_in == 3
    assert updated.quality == 6
  end

  test "The Quality of an item is never more than 50" do
    aged_brie = %Item{name: "Aged Brie", sell_in: 40, quality: 50}
    updated = GildedRose.update_item(aged_brie)
    assert updated.sell_in == 39
    assert updated.quality == 50
  end

  test "'Sulfuras', being a legendary item, never has to be sold or decreases in Quality" do
    sulfuras = %Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 40, quality: 80}
    updated = GildedRose.update_item(sulfuras)
    assert updated.sell_in == 40
    assert updated.quality == 80
  end

  describe "'Backstage passes', like aged brie, increases in Quality as its SellIn value approaches;" do
    test "Quality increases by 2 when there are 10 days or less" do
      pass = %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 10, quality: 10}
      updated = GildedRose.update_item(pass)
      assert updated.sell_in == 9
      assert updated.quality == 12
    end

    test "Quality increases by 3 when there are 5 days or less" do
      pass = %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 5, quality: 10}
      updated = GildedRose.update_item(pass)
      assert updated.sell_in == 4
      assert updated.quality == 13
    end

    test "Quality drops to 0 after the concert" do
      pass = %Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 0, quality: 10}
      updated = GildedRose.update_item(pass)
      assert updated.sell_in == -1
      assert updated.quality == 0
    end
  end

  describe "Conjured Mana Cake degrade twice as fast as normal items" do
    test "Within thier sell in date decrease by 2" do
      conjured = %Item{name: "Conjured Mana Cake", sell_in: 10, quality: 30}
      updated = GildedRose.update_item(conjured)
      assert updated.sell_in == 9
      assert updated.quality == 28
    end

    test "After expired decrease by 4 (2 * 2)" do
      conjured = %Item{name: "Conjured Mana Cake", sell_in: 0, quality: 30}
      updated = GildedRose.update_item(conjured)
      assert updated.sell_in == -1
      assert updated.quality == 26
    end
  end
end
