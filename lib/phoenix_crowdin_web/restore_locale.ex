defmodule PhoenixCrowdinWeb.RestoreLocale do
  require Logger
    def on_mount(:default, %{"locale" => locale}, _session, socket) do
      Gettext.put_locale(PhoenixCrowdinWeb.Gettext, locale)
      {:cont, socket}
    end

    # catch-all case
    def on_mount(:default, _params, _session, socket), do: {:cont, socket}

    def mount(:default, _params, %{"locale_cookie" => locale}, socket) do
      Gettext.put_locale(PhoenixCrowdinWeb.Gettext, locale)
      Logger.info("Restore Local :#{locale}")
      {:cont, socket}
    end
end
