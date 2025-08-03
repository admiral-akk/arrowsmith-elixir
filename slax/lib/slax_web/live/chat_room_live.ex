defmodule SlaxWeb.ChatRoomLive do
  use SlaxWeb, :live_view

  alias Slax.Chat
  alias Slax.Chat.Room

  def render(assigns) do
    ~H"""
    <div class="flex flex-col shrink-0 w-64 bg-slate-100">
      <div class="flex justify-between items-center shrink-0 h-16 border-b border-slate-300 px-4">
        <div class="flex flex-col gap-1.5">
          <h1 class="text-lg font-bold text-gray-800">
            Slax
          </h1>
        </div>
      </div>
      <div class="mt-4 overflow-auto">
        <div class="flex items-center h-8 px-3">
          <span class="ml-2 leading-none font-medium text-sm">Rooms</span>
        </div>
        <div id="rooms-list">
          <!-- Syntax which indicates looping using function component-->
          <!-- :for is shorthand syntax for
          <%= for room <- @rooms do %>
            <.room_link room={room} active={room.id == @room.id} />
          <% end %>
          and

          <.room_link room={room} active={room.id == @room.id} />

          is shorthand for

          {room_link(%{room: room, active: room.id == @room.id})}
          --> <.room_link :for={room <- @rooms} room={room} active={room.id == @room.id} />
        </div>
      </div>
    </div>
    <div class="flex flex-col grow shadow-lg">
      <div class="flex justify-between items-center shrink-0 h-16 bg-white border-b border-slate-300 px-4">
        <div class="flex flex-col gap-1.5">
          <h1 class="text-sm font-bold leading-none">
            #{@room.name}

            <.link
              class="font-normal text-xs text-blue-600 hover:text-blue-700"
              navigate={~p"/rooms/#{@room}/edit"}
            >
              Edit
            </.link>
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

  ## Define the "assigns" passed to room_link
  ##
  ## Not required, but allows compiler to warn if wrong type is passed.
  ## Can take :default
  ##
  attr :active, :boolean, required: true
  attr :room, Room, required: true

  ## Function component - takes an assigns map as arg, returns ~H
  ## https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html
  defp room_link(assigns) do
    ## ~p generates a path that's checked against router.ex
    ~H"""
    <.link
      class={
        [
          "flex items-center h-8 text-sm pl-8 pr-3",
          if(@active, do: "bg-slate-300", else: "hover:bg-slate-300")
          ## equivelant
          ## (@active && "bg-slate-300") || "hover:bg-slate-300"
          ## if(@active, do: "bg-slate-300", else: "hover:bg-slate-300")
        ]
      }
      patch={
        ## navigate == href for .link, allows for reusing the websocket
        ## patch == navigate for .hlink, allows reusing the socket (if you're navigating to the same LiveView)
        ## ~p generates a path that's checked against router.ex
        ## @room == @room.id in this context
        ~p"/rooms/#{@room}"
      }
    >
      <.icon name="hero-hashtag" class="h-4 w-4" />
      <span class={["ml-2 leading-none", @active && "font-bold"]}>
        {@room.name}
      </span>
    </.link>
    """
  end

  @spec mount(any(), any(), Phoenix.LiveView.Socket.t()) :: {:ok, map()}
  def mount(_params, _session, socket) do
    if connected?(socket) do
      IO.puts("mounting (connected)")
    else
      IO.puts("mounting (not connected)")
    end

    rooms = Chat.list_rooms()

    socket =
      socket
      |> assign(:rooms, rooms)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    IO.puts("handle_params #{inspect(params)} (connected: #{connected?(socket)})")

    room =
      case Map.fetch(params, "id") do
        {:ok, id} ->
          Chat.get_room!(id)

        :error ->
          List.first(socket.assigns.rooms)
      end

    socket =
      socket
      |> assign(:room, room)
      |> assign(:hide_topic?, false)
      |> assign(:page_title, "#" <> room.name)

    {:noreply, socket}
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
