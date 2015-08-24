defmodule Constable.Api.CommentController do
  use Constable.Web, :controller

  alias Constable.Comment

  plug :scrub_params, "comment" when action in [:create]

  def create(conn, %{"comment" => params}) do
    current_user = current_user(conn)
    params = Map.put(params, "user_id", current_user.id)

    changeset = Comment.changeset(:create, params)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        conn |> put_status(201) |> render("show.json", comment: comment)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(Constable.ChangesetView, "error.json", changeset: changeset)
    end
  end
end