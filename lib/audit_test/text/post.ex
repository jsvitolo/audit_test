defmodule AuditTest.Text.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuditTest.Text.Post


  schema "posts" do
    field :body, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
