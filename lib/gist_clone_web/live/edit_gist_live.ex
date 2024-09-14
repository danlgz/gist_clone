defmodule GistCloneWeb.EditGistLive do
  use GistCloneWeb, :live_view
  alias GistClone.Gists

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist_with_user!(id)
    form = to_form(Gists.change_gist(gist))

    socket = assign(socket, form: form)
    socket = assign(socket, gist: gist)

    {:ok, socket}
  end

  def handle_event("update", %{"gist" => params}, socket) do
    gist = socket.assigns.gist

    case Gists.update_gist(gist, params) do
      {:ok, _gist} ->
        {:noreply,
         socket |> put_flash(:info, "Gist updated") |> redirect(to: ~p"/gist/#{gist.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(form: to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <.gist_form for={@form} phx-submit="update" />
    """
  end
end
