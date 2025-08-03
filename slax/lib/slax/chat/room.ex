defmodule Slax.Chat.Room do
  use Ecto.Schema
  alias Slax.Chat.Message
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string
    field :topic, :string

    has_many :messages, Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :topic])
    |> validate_required(:name)
    |> validate_length(:name, max: 80)
    |> validate_format(:name, ~r/\A[a-z0-9-]+\z/,
      message: "can only contain lowercase letters, numbers and dashes"
    )
    |> validate_length(:topic, max: 200)
    ## actually checks the uniqueness in the DB
    |> unsafe_validate_unique(:name, Slax.Repo)
    ## catches constraint errors from the Db
    |> unique_constraint(:name)
  end
end
