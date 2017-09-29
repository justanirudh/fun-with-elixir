defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = start_supervised KV.Registry
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    #bucket = 'shopping' bucket which is the key to the value of the newly created bucket in Genserver.handle_cast
    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

# Our registry is almost complete. The only remaining issue is that the registry
# may become stale if a bucket stops or crashes. Let’s add a test to KV.RegistryTest that exposes this bug:
# The test above will fail on the last assertion as the bucket name remains in the registry even after 
# we stop the bucket process.

#this test will fail if bucket process (Agent) not monitored by registry (when dies, remove from registry)
  test "removes buckets on exit", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

end