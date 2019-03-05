defmodule Fitting do
  def mapper(%Box{a: a, b: b, c: c}, %Vector{x: x, y: y}) do
    scaled_b = Vector.scale(x, b)
    scaled_c = Vector.scale(y, c)

    Vector.add(a, Vector.add(scaled_b, scaled_c))
  end

  def get_stroke_width(%Box{b: b, c: c}) do
    max(Vector.length(b), Vector.length(c)) / 150.0
  end

  def create_picture(shapes, options \\ []) do
    debug = Keyword.get(options, :debug, false)

    fn box ->
      %{a: a, b: b, c: c} = box

      stroke_width = get_stroke_width(box)

      styled_shapes =
        shapes
        |> Enum.map(fn
          {:polygon, points} ->
            {:polygon, Enum.map(points, fn point -> mapper(box, point) end)}
        end)
        |> Enum.map(fn shape ->
          {shape, %{stroke: {stroke_width, :black}}}
        end)

      box_lines = [
        {{:polygon,
          [
            a,
            %Vector{x: 0.0, y: 0.0}
          ]}, %{stroke: {stroke_width, :red}}},
        {{:polygon,
          [
            a,
            Vector.add(a, b)
          ]}, %{stroke: {stroke_width, :orange}}},
        {{:polygon,
          [
            a,
            Vector.add(a, c)
          ]}, %{stroke: {stroke_width, :purple}}}
      ]

      if debug do
        box_lines ++ styled_shapes
      else
        styled_shapes
      end
    end
  end
end
