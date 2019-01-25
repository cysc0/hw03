defmodule Practice.Calc do
  
  ##################################################
  ########## Functions for the Calculator ##########
  ##################################################
  
  def calc(expr) do
    # main function for calculator
    # This should handle +,-,*,/ with order of operations,
    #   but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> Enum.map(fn x -> tag_token(x) end)
    |> postfixify
    |> solve
  end
  
  def get_rank(op) do
    # for calculating precedence in operations, return an operation's rank
    # should be an enumeration, should be refactored
    case elem(op, 1) do
      "+" -> 0
      "-" -> 0
      "*" -> 1
      "/" -> 1
    end
  end
  
  def postfixify(inputQueue) do
    # initial call to recursive postfix function for postfixifying an expr
    #   an expr should be a list of {(oneof :op, :num) (oneof "*+/-", float)}
    # Methodology for prefix -> postfix:
    #   https://www.geeksforgeeks.org/stack-set-2-infix-to-postfix/
    postfixify_inner(inputQueue, [], [])
  end
  
  def postfixify_inner(inputQueue, stack, acc) do
    # recursively process our inputQueue. according to the prefix->postfix algorithm,
    #   recursively process elements onto the stack, or into the output stream
    if length(inputQueue) == 0 do
      # if our input queue is empty, return our accumulator w/ any remnant operators
      acc ++ stack
    else
      # input queue not empty, continue recursion
      {curTuple, poppedList} = List.pop_at(inputQueue, 0)
      if elem(curTuple, 0) === :num do
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

  def solve(expr) do
    # initial call to solving function. as nums are encountered, push them into
    #   the stack. as operators are encountered, pop off 2 elemnts from the stack
    #   and apply them w/ the current operator. continue down recursion
    #   until the stack is a single element (and the input is empty), return that element
    solve_inner(expr, [])
  end

  def solve_inner(inputQueue, stack) do
    if length(inputQueue) === 0 do
      {res, _} = List.pop_at(stack, 0)
      elem(res, 1)
    else
      {curTuple, poppedList} = List.pop_at(inputQueue, 0)
      if elem(curTuple, 0) === :num do
        solve_inner(poppedList, [curTuple] ++ stack)
      else
        {rightSide, poppedStack} = List.pop_at(stack, 0)
        {leftSide, poppedStack2} = List.pop_at(poppedStack, 0)
        cond do
          elem(curTuple, 1) === "+" ->
            solve_inner(poppedList, [{:num, elem(leftSide, 1) + elem(rightSide, 1)}] ++ poppedStack2)
          elem(curTuple, 1) === "-" ->
            solve_inner(poppedList, [{:num, elem(leftSide, 1) - elem(rightSide, 1)}] ++ poppedStack2)
          elem(curTuple, 1) === "*" ->
            solve_inner(poppedList, [{:num, elem(leftSide, 1) * elem(rightSide, 1)}] ++ poppedStack2)
          elem(curTuple, 1) === "/" ->
            solve_inner(poppedList, [{:num, elem(leftSide, 1) / elem(rightSide, 1)}] ++ poppedStack2)
        end
      end
    end
  end
  
  def tag_token(elem) do
    # for processing our inputs element by element, map them as :op or :num tuples
    if Float.parse(elem) === :error do
      {:op, elem}
    else
      {num, _} = Float.parse(elem)
      {:num, num}
    end
  end
  
  ##################################################
  ########## Functions for the Factorizer ##########
  ##################################################

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
    # if x (current count) divided by curNum (current divisor) is remainder = 0
    #   add this curNum to the acc list.
    #   otherwise increment curNum and continue recursion.
    #   base case if x (current count) = 1, we're done: return acc
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