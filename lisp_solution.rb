# solution provided by Wai-Lee Chin Feman
# http://github.com/skatenerd/lisp

def is_boolean(argument)
  argument[0] == "#" and ["t","f"].include?(argument[1]) && argument.length == 2
end

def as_boolean(argument)
  {"#t" => true, "#f" => false}[argument]
end

def is_list(to_eval)
  to_eval[0] == "(" && to_eval[-1] == ")"
end

def get_operator(list)
  operator_from_string(list[0])
end

def get_arguments(list)
  list[1..-1]
end

def plus(a,b)
  a+b
end

def times(a,b)
  a*b
end

def operator_from_string(s)
  {"+" => "plus",
   "*" => "times"}[s]
end

def parse(thelist)
  thelist[1...-1].split
end

#["+"
# "1"
# "2"
# ["*" "3" "7"]]

def as_list(to_eval)
  as_array = parse(to_eval)
  operator = get_operator(as_array)
  raw_arguments = get_arguments(as_array)
  evaluated_arguments = raw_arguments.map {|a| lisp_eval a}
  evaluated_arguments.reduce do |total, current|
    __send__(operator,total, current)
  end
end

def lisp_eval(to_eval)
  return as_boolean(to_eval) if is_boolean(to_eval)
  return as_list(to_eval) if is_list(to_eval)

  to_eval.to_i
end
