defmodule AuditTestWeb.PageController do
  use AuditTestWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
