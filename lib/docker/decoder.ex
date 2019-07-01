defmodule Docker.Decoder do
  use Behaviour

  @doc """
    decode a buffer and return one object
  """
  defcallback decode!(chunk :: String.t) :: any

  @doc """
    decode a chunk, return list of objects and decode status
  """
  defcallback decode_chunk!(chunk :: String.t, last :: any) :: {any,any}

  defcallback flush!(status :: any) :: any
end
