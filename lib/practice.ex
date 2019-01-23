defmodule Practice do
  @moduledoc """
  Practice keeps the contexts that define your domain
  and business logic.
  
  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  
  def double(x) do
    2 * x
  end
  
  def calc(expr) do
    # This is more complex, delegate to lib/practice/calc.ex
    Practice.Calc.calc(expr)
  end
  
  def factor(x) when is_integer(x) do
    # Delegate to lib/practice/calc.ex
    # return as stringified list
    result = Practice.Calc.factorize(x)
    if result === 0 do # hanlde errors when input is < 2
    0
    else
      result
    end
  end
  
  def factor(x) when is_bitstring(x) do
    # handle string input version
    factor(String.to_integer(x))
  end
  
  def palindrome(expr) do
    # Compare lowercase to reversed lowercase
    String.downcase(expr) === String.downcase(String.reverse(expr))
  end
end
