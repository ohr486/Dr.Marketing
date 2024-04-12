defmodule DrMarketing.Repo do
  use Ecto.Repo,
    otp_app: :dr_marketing,
    adapter: Ecto.Adapters.MyXQL
end
