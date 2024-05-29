defmodule Inertia.Controller do
  @moduledoc """
  Controller functions for rendering Inertia.js responses.
  """

  require Logger

  alias Inertia.SSR

  import Phoenix.Controller
  import Plug.Conn

  @doc """
  Assigns a prop value to the Inertia page data.
  """
  @spec assign_prop(Plug.Conn.t(), atom(), any()) :: Plug.Conn.t()
  def assign_prop(conn, key, value) do
    shared = conn.private[:inertia_shared] || %{}
    put_private(conn, :inertia_shared, Map.put(shared, key, value))
  end

  @doc """
  Renders an Inertia response.
  """
  @spec render_inertia(Plug.Conn.t(), component :: String.t()) :: Plug.Conn.t()
  @spec render_inertia(Plug.Conn.t(), component :: String.t(), props :: map()) :: Plug.Conn.t()

  def render_inertia(conn, component, props \\ %{}) do
    shared = conn.private[:inertia_shared] || %{}
    props = Map.merge(shared, props)

    conn
    |> put_private(:inertia_page, %{component: component, props: props})
    |> send_response()
  end

  # Private helpers

  defp send_response(%{private: %{inertia_request: true}} = conn) do
    conn
    |> put_status(200)
    |> put_resp_header("x-inertia", "true")
    |> put_resp_header("vary", "X-Inertia")
    |> json(inertia_assigns(conn))
  end

  defp send_response(conn) do
    if ssr_enabled?() do
      case SSR.call(inertia_assigns(conn)) do
        {:ok, %{"head" => head, "body" => body}} ->
          # TODO: remove this
          Logger.debug("head #{inspect(head)}")
          send_ssr_response(conn, head, body)

        _err ->
          send_csr_response(conn)
      end
    else
      send_csr_response(conn)
    end
  end

  defp compile_head(%{assigns: %{inertia_head: current_head}} = conn, head) do
    assign(conn, :inertia_head, current_head ++ head)
  end

  defp send_ssr_response(conn, head, body) do
    conn
    |> put_view(Inertia.HTML)
    |> compile_head(head)
    |> assign(:body, body)
    |> render(:inertia_ssr)
  end

  defp send_csr_response(conn) do
    conn
    |> put_view(Inertia.HTML)
    |> render(:inertia_page, inertia_assigns(conn))
  end

  defp inertia_assigns(conn) do
    %{
      component: conn.private.inertia_page.component,
      props: conn.private.inertia_page.props,
      url: request_path(conn),
      version: conn.private.inertia_version
    }
  end

  defp request_path(conn) do
    IO.iodata_to_binary([conn.request_path, request_url_qs(conn.query_string)])
  end

  defp request_url_qs(""), do: ""
  defp request_url_qs(qs), do: [??, qs]

  defp ssr_enabled? do
    Application.get_env(:inertia, :ssr, false)
  end
end
