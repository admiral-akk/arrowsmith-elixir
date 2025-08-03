defmodule SlaxWeb.ChatRoomLive do
  use SlaxWeb, :live_view

  def render(assigns) do
    person = {}
    Map.update(assigns, "page_title", "test", fn _ -> "test" end)

    ~H"""
    <div>Welcome to the chat!</div>
    <div>{2 + 2}</div>
    <div>{2 + 3}</div>
    <div><%!-- this is a comment --%></div>
    <div><%!-- the below runs but doesn't render anything--%></div>
    <div><% 3 + 4 %></div>
    <div id={"person-#{}"} class="person">
      I'm a person
    </div>
    {"<div>Welcome to the chat!</div>"}
    """
  end
end
