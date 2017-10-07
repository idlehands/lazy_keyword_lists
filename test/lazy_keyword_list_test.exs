defmodule LazyKeywordListTest do
  use ExUnit.Case
  import LazyKeywordList

  describe "basic use:" do
    test "returns simple keyword list with variables" do
      bob = "value1"
      jim = "value2"

      assert ~k(bob jim) === [bob: bob, jim: jim]
    end

    test "accepts default value" do
      assert ~k(bob jim | true) === [bob: true, jim: true]
    end
  end

  describe "validations" do
    test "raises on invalid key/variable name" do
      assert_raise ArgumentError, ~r/1 invalid: names must start with a lower case letter/, fn ->
        bad_call = quote do: ~k(1)
        Code.eval_quoted(bad_call)
      end
    end
  end
end
