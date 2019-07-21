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

defmodule Docker.RawDecoder do
  @behaviour Docker.Decoder

  def decode!(chunk), do: chunk
  def decode_chunk!(chunk,_), do: {chunk, nil}
  def flush!(_), do: nil
end

defmodule Docker.JsonDecoder do
  @behaviour Docker.Decoder

  def decode!(chunk) do
    Jason.decode!(chunk)
  end

  #based on facts that docker sends one JSON object in a chunk,
  #if this is changed, this will fail.
  def decode_chunk!(chunk,"") do
    {decode!(chunk),""}
  end

  def flush!(""), do: nil
  def flush!(chunk), do: decode! chunk
end

defmodule Docker.PackedDecoder do
  @behaviour Docker.Decoder

  def decode!(chunk) do
    {ret, _} = _decode chunk,[]
    ret
  end
  def decode_chunk!(chunk, last_chunk) do
    bytes = last_chunk <> chunk
    case _decode bytes, [] do
      {[], rest} -> {nil, rest}
      result -> result
    end
  end
  def flush!(""), do: nil
  def flush!(_) do
    raise ArgumentError
  end

  def _decode(<<type,0,0,0,size :: integer-big-size(32),rest :: binary>>=packet, acc) do
    if size <= byte_size(rest) do
      <<data :: binary-size(size), rest0 :: binary>> = rest
      type = case type do
        0 -> :stdin
        1 -> :stdout
        2 -> :stderr
        other -> other
      end
      acc = [{type,data}|acc]
      _decode(rest0, acc)
    else
      {Enum.reverse(acc), packet}
    end
  end
  def _decode(packet, acc) when byte_size(packet)<8 do
    {Enum.reverse(acc), packet}
  end
  def _decode(packet, _acc) do
    raise ArgumentError
  end

end
