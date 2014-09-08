def add_operator(lisp_object)
  lisp_object[:value][1..-1].inject(0) do |r_val, arg_lisp_object|
    r_val + eval_lisp_object(arg_lisp_object)
  end
end

def build_fn_args(fn_args, fn_arg_values)
  args = []
  fn_args.each_with_index do |arg_name, index|
    args << arg_name << fn_arg_values[index]
  end
  s_expression_object(args)
end

def call_function(lisp_object)
  fn = @fns[lisp_object[:value][0][:value]]
  let_context = @let_vars
  @let_vars = [{}]
  function_call = [
      let_lisp_object,
      build_fn_args(fn[:fn_args][:value], lisp_object[:value][1..-1]),
      fn[:fn_body]
  ]
  r_val = eval_lisp_object(s_expression_object(function_call))
  @let_vars = let_context
  r_val
end

def def_operator(lisp_object)
  identifier = lisp_object[:value][1][:value]
  @vars[identifier] = eval_lisp_object(lisp_object[:value][2])
end

def defn_operator(lisp_object)
  defn_expression = lisp_object[:value]
  @fns[defn_expression[1][:value]] = {
    :fn_args => defn_expression[2],
    :fn_body => defn_expression[3]
  }
end

def eval_lisp_object(lisp_object)
  if lisp_object[:type]
    case lisp_object[:type]
      when :s_expr
        fn = lisp_object[:value][0]
        case fn[:type]
          when :operator
            if fn[:value] == :+
              return add_operator(lisp_object)
            else
              return multiply_operator(lisp_object)
            end
          when :def
            return def_operator(lisp_object)
          when :defn
            return defn_operator(lisp_object)
          when :function_call
            return call_function(lisp_object)
          when :if
            return if_operator(lisp_object)
          when :let
            return let_operator(lisp_object)
          else
            return nil
        end
      when :identifier
        @let_vars.each do |let_env|
          return let_env[lisp_object[:value]] if let_env.has_key?(lisp_object[:value])
        end
        return @vars[lisp_object[:value]]
      else
        return nil
    end
  end
  lisp_object[:value]
end

def if_operator(lisp_object)
  if_expression = lisp_object[:value]
  eval_lisp_object(if_expression[eval_lisp_object(if_expression[1]) ? 2 : 3])
end

def let_lisp_object
  {:type => :let}
end

def let_operator(lisp_object)
  @let_vars.unshift({})
  var_args = lisp_object[:value][1][:value]
  while var_args != []
    identifier = var_args[0][:value]
    value = eval_lisp_object(var_args[1])
    @let_vars[0][identifier] = value
    var_args = var_args[2..-1]
  end
  r_val = eval_lisp_object(lisp_object[:value][2])
  @let_vars.shift
  r_val
end

def lisp_eval(expression)
  @let_vars = [{}]
  @vars = {}
  @fns = {}
  r_val = nil
  while expression != ''
    lisp_object, expression = read_lisp_object(expression)
    r_val = eval_lisp_object(lisp_object)
  end
  r_val
end

def multiply_operator(lisp_object)
  lisp_object[:value][1..-1].inject(1) do |r_val, arg_lisp_object|
    r_val * eval_lisp_object(arg_lisp_object)
  end
end

def read_lisp_object(lisp_object_expr)
  lisp_object, _, remainder = read_lisp_object1(lisp_object_expr)
  return lisp_object, remainder
end

def read_lisp_object1(lisp_object_expr)
  tokens = /\s*(\(|[^\s\(\)]+|\))(.*)/m.match(lisp_object_expr)
  first_token, remainder = tokens[1], tokens[2]
  lisp_object =
      case first_token
        when /^[\-\+]?\d+$/
          {:value => lisp_object_expr.to_i}
        when '+', '*'
          {:type => :operator, :value => first_token.to_sym}
        when '#t'
          {:value => true}
        when '#f'
          {:value => false}
        when '('
          args = []
          while first_token != ')'
            arg, first_token, remainder = read_lisp_object1(remainder)
            args << arg if first_token != ')'
          end
          first_token = nil
          s_expression_object(args)
        when ')'
          nil
        when 'let'
          let_lisp_object
        when 'def'
          {:type => :def}
        when 'defn'
          {:type => :defn}
        when 'if'
          {:type => :if}
        when /^\w+$/
          {:type => @fns.has_key?(first_token) ? :function_call : :identifier, :value => first_token}
        else
          {:type => :unknown, :value => first_token}
      end
  return lisp_object, first_token, remainder
end

def s_expression_object(args)
  {:type => :s_expr, :value => args}
end
