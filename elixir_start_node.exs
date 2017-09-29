defmodule ExDistUtils do
  def start_distributed(appname) do
    unless Node.alive?() do
      local_node_name = generate_name(appname)
      {:ok, _} = Node.start(local_node_name)
    end
    cookie = Application.get_env(appname, :cookie)
    Node.set_cookie(cookie)
  end

  defp generate_name(appname) do
    machine = Application.get_env(appname, :machine, "localhost")
    hex = :erlang.monotonic_time() |>
      :erlang.phash2(256) |>
      Integer.to_string(16)
    String.to_atom("#{appname}-#{hex}@#{machine}")
  end
end
ExDistUtils.start_distributed("foo")