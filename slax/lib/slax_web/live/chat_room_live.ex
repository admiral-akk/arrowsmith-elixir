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
          <div
            class={["text-xs leading-none h-3.5", @hide_topic? && "text-slate-600"]}
            phx-click="toggle-topic"
          >
            <%= if @hide_topic? do %>
              [Topic hidden]
            <% else %>
              {@room.topic}
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      IO.puts("mounting (connected)")
    else
      IO.puts("mounting (not connected)")
    end

    room = Room |> Repo.all() |> List.first()

    socket =
      socket
      |> assign(:room, room)
      |> assign(:hide_topic?, false)

    {:ok, socket}
  end

  def handle_event("toggle-topic", _params, socket) do
    socket =
      socket
      ## &() == fn x -> x end
      ## &1 == first arg
      |> update(:hide_topic?, &(!&1))

    {:noreply, socket}
  end
end
