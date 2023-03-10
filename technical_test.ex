defmodule TechnicalTest do
  @moduledoc """
    1. Recibe una cadena de texto que represente una operación aritmética, por ejemplo: "10 + 25 – 125 * 2 - 4 + 89"
    2. Sin tomar en cuenta la precedencia de operadores, procesar la operación aritmética. En el ejemplo anterior la respuesta debería ser: “-95”
    3. La aplicación debe ser capaz de procesar cualquier cadena de texto, con cifras de cualquier cantidad de dígitos y cualquier número de operaciones aritméticas básicas (suma, resta y multiplicación únicamente).
    4. El lenguaje a utilizar deberá ser Elixir.
    5. No es requerida una interfaz gráfica.
    6. Puntos adicionales si la aplicación es capaz de procesar la operación división.
    7. Por ejemplo, la cadena "22 – 14 / 3 + 58 * 5 – 22 / 2" debería dar como resultado: “140.66666…”
    8. Puntos adicionales si la aplicación es capaz de procesar la cadena de texto en orden reversible, esto es, de izquierda a derecha y de derecha a izquierda.
  """

  @doc """
  `transform/2` interpret a sentence.

  ## Example

      iex(1)> TechnicalTest.transform("10 + 25 - 125 * 2 - 4 + 89")
      -95.0
  
  Optionally you can add the order to interpret the sentence `:forward` or `:reverse`
  ## Example

      iex(1)> TechnicalTest.transform("10 + 25 - 125 * 2 - 4 + 89", :reverse)
      11360.0

  If the sentence contains any invalid characters, it will be ignored.
  """

  def transform(sentence, order \\ :forward)

  def transform("", _), do: "Something went wrong :("

  def transform(<<sentence::binary>>, order) do
    sentence
    |> String.split(" ", trim: true)
    |> Enum.map(&parse/1)
    |> validate_order(order)
    |> compute()
  end

  def transform(_, _), do: "Something went wrong :("

  defp validate_order(list, :reverse), do: Enum.reverse(list)

  defp validate_order(list, _forward), do: list

  defp parse(elem) when elem in ["+", "-", "*", "/"], do: elem

  defp parse(elem) do
    elem
    |> Float.parse()
    |> case do
      {float, _} -> 
        float
      _error -> 
        0.0
    end
  end

  defp compute([]), do: []

  defp compute([result]), do: result
  
  defp compute([x, op, y | rest]) do
    calculate(x, op, y)
    |> Enum.concat(rest)
    |> compute()
  end

  defp calculate(x, "+", y) when is_float(x) and is_float(y), do: [x + y]
  defp calculate(x, "-", y) when is_float(x) and is_float(y), do: [x - y]
  defp calculate(x, "*", y) when is_float(x) and is_float(y), do: [x * y]
  defp calculate(x, "/", y) when is_float(x) and is_float(y), do: [x / y]
  defp calculate(_, _, _), do: [0]
end
