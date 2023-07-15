defmodule PhoenixCrowdin.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_crowdin,
    adapter: Ecto.Adapters.Postgres
end
