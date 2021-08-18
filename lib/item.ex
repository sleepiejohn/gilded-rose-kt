defmodule Item do
  defstruct name: nil, sell_in: nil, quality: nil

  def update(%Item{name: "Aged Brie"} = item), do: update(item, 1)

  def update(%Item{name: "Sulfuras, Hand of Ragnaros"} = item), do: item

  def update(%Item{name: "Backstage passes to a TAFKAL80ETC concert"} = item) do
    item = descrease_sell_in(item)

    quality =
      cond do
        item.sell_in < 0 -> -1 * item.quality
        item.sell_in <= 5 -> 3
        item.sell_in <= 10 -> 2
        true -> 1
      end

    inc_quality_by(item, quality)
  end

  def update(%Item{name: "Conjured Mana Cake"} = item), do: update(item, -2)

  def update(item), do: update(item, -1)

  defp descrease_sell_in(item), do: %Item{item | sell_in: item.sell_in - 1}

  defp update(item, inc_quality),
    do:
      item
      |> descrease_sell_in()
      |> inc_quality_by(inc_quality)

  defp inc_quality_by(item, inc_quality) do
    new_quality = item.quality + double_quality(item, inc_quality)

    cond do
      new_quality > 50 -> 50
      new_quality < 0 -> 0
      true -> new_quality
    end
  end

  # doubles the incrementing quality when the date of sell has passed
  defp double_quality(item, inc_quality),
    do: if(item.sell_in < 0, do: inc_quality * 2, else: inc_quality)
end
