defmodule NearbyBookWeb.Middleware.TranslateMessages do
  @behaviour Absinthe.Middleware
  def call(%{value: value} = resolution, _config) do
    result = do_translate_messages(value)
    Absinthe.Resolution.put_result(resolution, {:ok, result})
  end

  defp do_translate_messages(%Kronky.Payload{} = payload) do
    Map.update!(payload, :messages, fn(messages) ->
      Enum.map(messages, &translate_message/1)
    end)
  end
  defp do_translate_messages(value), do: value

  defp translate_message(%Kronky.ValidationMessage{} = validation_message) do
    # TODO 这里每条message都有内容和type两种，需要好好利用一下
    opts = Map.get(validation_message, :options)
    template = Map.get(validation_message, :template)

    Map.update!(validation_message, :message, fn _message ->
      if count = opts[:count] do
        Gettext.dngettext(NearbyBookWeb.Gettext, "errors", template, template, count, opts)
      else
        Gettext.dgettext(NearbyBookWeb.Gettext, "errors", template, opts)
      end
    end)
  end
end
