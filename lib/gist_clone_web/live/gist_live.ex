defmodule GistCloneWeb.GistLive do
  use GistCloneWeb, :live_view
  alias GistClone.Gists

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist_with_user!(id)
    socket = assign(socket, gist: gist)

    num_of_lines = gist.markup_text |> String.split("\n") |> length()
    socket = assign(socket, num_of_lines: num_of_lines)

    {:ok, socket}
  end

  def handle_event("delete_gist", _, socket) do
    gist = socket.assigns.gist

    case Gists.delete_gist(gist) do
      {:ok, _gist} ->
        {:noreply, socket |> redirect(to: ~p"/")}

      {:error, %Ecto.Changeset{}} ->
        {:noreply, socket |> put_flash(:error, "Gist delete error")}
    end
  end
end
