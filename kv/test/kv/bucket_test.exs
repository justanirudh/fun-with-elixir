#https://elixir-lang.org/getting-started/mix-otp/agent.html
defmodule KV.BucketTest do
  use ExUnit.Case, async: true

#callback(spawning off a function), runs before every test
  setup do
    {:ok, bucket} = start_supervised(KV.Bucket)
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do #pattern matches callbacked bucket map
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end
end