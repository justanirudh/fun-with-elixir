defmodule Helloer do
    def hola(msg) do
      IO.puts "Hola! #{msg}"
    end
end
  
IO.puts "Parent process is #{inspect self}" 
IO.puts "Spawned process is #{inspect spawn(Helloer, :hola, ['Elixir is awesome'])}"