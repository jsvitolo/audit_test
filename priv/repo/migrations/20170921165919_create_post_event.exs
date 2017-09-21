defmodule AuditTest.Repo.Migrations.CreatePostEvent do
  use Ecto.Migration

  def change do
    create table(:posts_event) do
      add :changes, :map
      add :committed_by, :integer
      add :committed_at, :utc_datetime
    end

  end
end
