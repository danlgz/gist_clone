defmodule GistCloneWeb.GistComponents do
  use Phoenix.Component

  import GistCloneWeb.CoreComponents

  attr :for, :map, required: true, doc: "Gist for the form"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  def gist_form(assigns) do
    ~H"""
    <.simple_form class="flex flex-col" for={@for} {@rest}>
      <.input
        field={@for[:description]}
        label="Description"
        placeholder="Gist description..."
        autocomplete="off"
        phx-debounce="500"
      />
      <div class="bg-gistDark-dark rounded-lg border border-gistPurple">
        <div class="p-4">
          <.input
            placeholder="my_file.ex (include extension for higlights)"
            field={@for[:name]}
            autocomplete="off"
            class="max-w-xl"
            phx-debounce="500"
          />
        </div>
        <.input
          field={@for[:markup_text]}
          type="textarea"
          placeholder="Content..."
          class="rounded-md rounded-tr-none rounded-tl-none min-h-96 border-0 border-t"
          phx-debounce="500"
        />
      </div>

      <:actions>
        <.button type="submit" phx-disable-with="Creating...">Submit</.button>
      </:actions>
    </.simple_form>
    """
  end
end
