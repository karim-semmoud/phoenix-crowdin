defmodule PhoenixCrowdinWeb.Locale do
  alias Plug.Conn

  @locales Gettext.known_locales(PhoenixCrowdinWeb.Gettext)

  @cookie "PhoenixCrowdinCookie"
  @ten_days 10 * 24 * 60 * 60

  defguard known_locale?(locale) when locale in @locales

  def init(_opts), do: nil

  def call(conn, _opts) do
    locale = fetch_and_set_locale(conn)

    conn
    |> persist_locale(locale)
  end

  defp fetch_and_set_locale(conn) do
    case locale_from_params(conn) || locale_from_cookies(conn) || locale_from_header(conn) do
      nil ->
        # This will fallback to the default locale set in `config.exs`
        Gettext.get_locale()

      locale ->
        # Update the global locale only if the `locale` value
        # is different to it
        if locale != Gettext.get_locale() do
          Gettext.put_locale(locale)
        end

        locale
    end
  end

  defp locale_from_params(%Conn{params: %{"locale" => locale}})
       when known_locale?(locale) do
    locale
  end

  defp locale_from_params(_conn), do: nil

  defp locale_from_cookies(%Conn{cookies: %{@cookie => locale}})
       when known_locale?(locale) do
    locale
  end

  defp locale_from_cookies(_conn), do: nil

  defp persist_locale(%Conn{cookies: %{@cookie => locale}} = conn, locale) do
    # Cookie locale is the same as the current locale, so do nothing and just
    # return the original `conn`
    conn
  end

  defp persist_locale(conn, locale) do
    Conn.put_resp_cookie(conn, @cookie, locale, max_age: @ten_days)
  end

  defp locale_from_header(conn) do
    result = Locale.Headers.extract_accept_language(conn)

    Enum.reduce(result, nil, fn locale, acc ->
      if known_locale?(locale) do
        locale
      else
        acc
      end
    end)
  end
end
