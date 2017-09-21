defmodule AuditTest.Repo do
  use Ecto.Repo, otp_app: :audit_test
  use AuditTest.Events.Repo

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
