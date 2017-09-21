defmodule AuditTest.Text.PostEvent do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditTest.Text.PostEvent

  schema "posts_event" do
    field :changes, :map
    field :committed_by, :integer
    field :committed_at, :utc_datetime
  end

  @doc false
  def changeset(%PostEvent{} = post_event, attrs) do
    post_event
    |> cast(attrs, [:changes, :committed_by, :committed_at])
    |> validate_required([:changes, :committed_by, :committed_at])
  end
end
