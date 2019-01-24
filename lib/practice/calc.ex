defmodule Practice.Calc do
  def tag_token(elem) do
    if Float.parse(elem) === :error do
      {:op, elem}
    else
      {num, _} = Float.parse(elem)
      {:num, num}
    end
  end
  
  def get_rank(op) do
    case elem(op, 1) do
      "+" -> 0
      "-" -> 0
      "*" -> 1
      "/" -> 1
    end
  end
  
  def postfixify(inputQueue) do
    # Methodology for prefix -> postfix:
    #   https://www.geeksforgeeks.org/stack-set-2-infix-to-postfix/
    postfixify_inner(inputQueue, [], [])
  end
  
  def postfixify_inner(inputQueue, stack, acc) do
    if length(inputQueue) == 0 do
      # if our input queue is empty, return our accumulator w/ any remnant operators
      acc ++ stack
    else
      # input queue not empty, continue recursion
      {curTuple, poppedList} = List.pop_at(inputQueue, 0)
      if elem(curTuple, 0) == :num do
        # any operand is instalty added to the accumulator
        postfixify_inner(poppedList, stack, acc ++ [curTuple])
      else
        if length(stack) == 0 do
          # if our operator stack is zero, replace it w/ current operator
          postfixify_inner(poppedList, [curTuple], acc)
        else
          # operator stack is non-empty
          {storedOp, _} = List.pop_at(stack, 0)
          if get_rank(storedOp) < get_rank(curTuple) do
            # if current operator is higher precedence than top of stack
            #   add it to the front of the stack
            postfixify_inner(poppedList, [curTuple] ++ stack, acc)
          else
            # if current operator is lower precedence than top of stack
            #   take any operators in stack greater than current operator and
            #   add them to the accumulator
            #   leave any other operators in the stack, stack the current operator
            gtRank = Enum.filter(stack, fn x -> get_rank(x) >= get_rank(curTuple) end)
            ltRank = Enum.filter(stack, fn x -> get_rank(x) < get_rank(curTuple) end)
            postfixify_inner(poppedList, [curTuple] ++ ltRank, acc ++ gtRank)
          end
        end
      end
    end
  end
  
  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> Enum.map(fn x -> tag_token(x) end)
    |> postfixify
    |> Enum.reverse
    |> IO.inspect
    IO.write("^^^ final")
    # |> TODO: evaluate as a stack calculator using pattern matching
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