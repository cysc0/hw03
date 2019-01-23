defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> hd
    |> parse_float
    |> :math.sqrt()
    # TODO: make me work
    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end

  def factorize(x) do
    # initial non-recursive call
    # would use Integer.parse(), but the string op seems more suitable
    if x <= 1 do
      0 # return error value for bad input (less than 2)
    else
      factorize_inner(x, 2, []) # start base case
    end
  end

  def factorize_inner(x, curNum, acc) do
    if x === 1 do  # terminal case: x === 1, return accumulated list
      acc
    else
      if rem(x, curNum) === 0 do
        # if this curNum is the next prime factor, store and continue
        factorize_inner(div(x, curNum), curNum, acc ++ [curNum])
      else # this curNum is not a factor, increment it and continue
        factorize_inner(x, curNum + 1, acc)
      end
    end
  end
end
