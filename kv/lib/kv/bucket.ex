#https://elixir-lang.org/getting-started/alias-require-and-import.html
defmodule KV.Bucket do
  use Agent

  @doc """
  Starts a new bucket.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(bucket, key) do
  #agent is server, caller is client
    Agent.get(bucket, &Map.get(&1, key)) #https://stackoverflow.com/questions/23357748/whats-up-with-this-anonymous-function-syntax
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  #actual contents of each bucket map vs registry map in Registry
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc """
    Deletes `key` from `bucket`.

    Returns the current value of `key`, if `key` exists.
    """
#     same as 
#     def delete(bucket, key) do
#       Agent.get_and_update(bucket, fn dict ->
#       Map.pop(dict, key)
#       end)
#    end

def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
end

end