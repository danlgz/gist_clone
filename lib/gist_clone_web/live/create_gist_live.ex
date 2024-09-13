defmodule GistCloneWeb.CreateGistLive do
  use GistCloneWeb, :live_view
  alias GistClone.{Gists, Gists.Gist}

  def mount(_params, _session, socket) do
    socket = assign(socket, form: to_form(Gists.change_gist(%Gist{})))
    {:ok, socket}
  end

  def handle_event("save", %{"gist" => gist_params}, socket) do
    case Gists.create_gist(socket.assigns.current_user, gist_params) do
      {:ok, gist} ->
        {:noreply,
         socket |> put_flash(:info, "Gist created!") |> redirect(to: ~p"/gist/#{gist.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    form = %Gist{} |> Gists.change_gist(params) |> to_form(action: :validate)

    {:noreply, assign(socket, form: form)}
  end

  def render(assigns) do
    ~H"""
    <.gist_form for={@form} phx-submit="save" phx-change="validate" />
    """
  end
end
