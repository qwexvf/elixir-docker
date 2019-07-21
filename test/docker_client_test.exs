defmodule DockerClientTest do
  use ExUnit.Case
  doctest DockerClient

  test "greets the world" do
    assert DockerClient.hello() == :world
  end
end
