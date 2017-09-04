defmodule ProcessLinking do
  def explode, do: exit(:kaboom)
  def run do
    Process.flag(:trap_exit, true)
    spawn_link(ProcessLinking, :explode, [])

    receive do
      {:EXIT, from_pid, reason} -> IO.puts "Exit reason: #{reason}"
    end
  end
end