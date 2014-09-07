require './spec_helper'
require './lisp'

describe '#lisp_eval' do
  describe "CHALLENGE 1" do
    it "lisp_evaluates numbers" do
      expect(lisp_eval("1")).to eq(1)
    end

    it "lisp_evaluates booleans" do
      expect(lisp_eval("#t")).to eq(true)
    end
  end

  describe "CHALLENGE 2", pending: true do
    it "lisp_evaluates addition" do
      expect(lisp_eval("(+ 1 2)")).to eq(3)
    end

    it "lisp_evaluates multiplication" do
      expect(lisp_eval("(* 2 2 3)")).to eq(12)
    end
  end

  describe "CHALLENGE 3", pending: true do
    it "lisp_evaluates nested arithmetic" do
      expect(lisp_eval("(+ 1 (* 2 3))")).to eq(7)
    end
  end

  describe "CHALLENGE 4", pending: true do
    it "lisp_evaluates conditionals" do
      expect(lisp_eval("(if #t 1 2)")).to eq(1)
      expect(lisp_eval("(if #f #t #f)")).to eq(false)
    end
  end

  describe "CHALLENGE 5", pending: true do
    it "lisp_evaluates top-level defs" do
      expect(lisp_eval("(def x 3)
                        (+ x 1)")).to eq(4)
    end
  end

  describe "CHALLENGE 6", pending: true  do
    it "lisp_evaluates simple `let` bindings" do
      expect(lisp_eval("(let (x 3)
                         x)")).to eq(3)
    end
  end

  describe "CHALLENGE 7", pending: true  do
    it "lisp_evaluates let bindings with a more sophisticated body" do
      expect(lisp_eval("(let (x 3)
                          (+ x 1))")).to eq(4)
    end
  end

  describe "CHALLENGE 8", pending: true  do
    it "lisp_evaluates let bindings with multiple variables" do
      expect(lisp_eval("(let (x 3
                              y 4)
                          (+ x y))")).to eq(7)
    end
  end

  describe "CHALLENGE 9", pending: true  do
    it "lisp_evaluates function definitions with single variables" do
      code = "(defn add2 (x)
                (+ x 2))

              (add2 10)"

      expect(lisp_eval(code)).to eq(12)
    end
  end

  describe "CHALLENGE 10", pending: true  do
    it "lisp_evaluates function definitions with multiple variables" do
      code = "(defn maybeAdd2 (bool x)
                (if bool
                  (+ x 2)
                  x))

              (+ (maybeAdd2 #t 1) (maybeAdd2 #f 1))"

      expect(lisp_eval(code)).to eq(4)
    end
  end
end
