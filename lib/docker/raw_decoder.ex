defmodule Docker.RawDecoder do
  @behaviour Docker.Decoder

  def decode!(chunk), do: chunk
  def decode_chunk!(chunk,_), do: {chunk, nil}
  def flush!(_), do: nil
end
