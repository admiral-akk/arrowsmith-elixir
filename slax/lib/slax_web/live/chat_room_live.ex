defmodule SlaxWeb.ChatRoomLive do
  use SlaxWeb, :live_view

  alias Slax.Chat.Room
  alias Slax.Repo

  def render(assigns) do
    ~H"""
    <div>Welcome to the chat!</div>
    <div class="flex flex-col grow shadow-lg">
      <div class="flex justify-between items-center shrink-0 h-16 bg-white border-b border-slate-300 px-4">
        <div class="flex flex-col gap-1.5">
          <h1 class="text-sm font-bold leading-none">
            #{assigns.room.name}
          </h1>
          <div class="text-xs leading-none h-3.5">
            #{assigns.room.topic}
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    room = Room |> Repo.all() |> List.first()

    socket =
      socket
      |> assign(:room, room)
      |> assign(:something, "Tommy Wiseau")

    {:ok, socket}
  end
end
