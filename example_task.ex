defmodule ExampleTask do
    def double(x) do
      :timer.sleep(2000)
      x * 2
    end
  end