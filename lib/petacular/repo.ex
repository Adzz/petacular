defmodule Petacular.Repo do
  use Ecto.Repo,
    otp_app: :petacular,
    adapter: Ecto.Adapters.Postgres
end
