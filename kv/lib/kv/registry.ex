#both client and server code can be in the same Module!
#https://elixir-lang.org/getting-started/mix-otp/genserver.html
defmodule KV.Registry do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  #first arg: The module where the server callbacks are implemented, in this case __MODULE__, 
  #meaning the current module
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name}) #sync call
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name}) #async call
  end

  @doc """
  Stops the registry.
  """
  def stop(server) do
    GenServer.stop(server)
  end

  ## Server Callbacks

#name to bucket map
def init(:ok) do
  names = %{} #name to pid of bucket
  refs  = %{} #monitoring ref to name
  {:ok, {names, refs}}#:ok sent as initiating param from start_link, initializing empty maps
end

#sync calls
def handle_call({:lookup, name}, _from, {names, _} = state) do #names and refs was instantiated as the initial state in init
  {:reply, Map.fetch(names, name), state}
end

#async calls
def handle_cast({:create, name}, {names, refs}) do
  if Map.has_key?(names, name) do
    {:noreply, {names, refs}}
  else
    {:ok, pid} = KV.Bucket.start_link([])
    ref = Process.monitor(pid) #monitor process. If it fails, send msg to this process
    refs = Map.put(refs, ref, name)
    names = Map.put(names, name, pid)
    {:noreply, {names, refs}}
  end
end

#handle_info handles monitoring messages to GenServer
def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
  {name, refs} = Map.pop(refs, ref) #if bucket stopped, remove from ref(got from monitoring info) -> name map
  names = Map.delete(names, name) # remove from name to pid map
  {:noreply, {names, refs}}
end

def handle_info(_msg, state) do #catch all to ignore any unknown msg; any 'send' to this process comes here except the cast and call
  {:noreply, state}
end
end