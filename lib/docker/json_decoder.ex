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
