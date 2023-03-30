defmodule Traefik.HandlerTest do
  use ExUnit.Case

  import Traefik.Handler, only: [handle: 1]

  test "GET /developers" do
    request = """
    GET /developers HTTP/1.1
    Host: makingdevs.com
    User-Agent: MyBrowser/0.1
    Accept: */*

    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Content-Type: text/html
           Content-Lenght: 16

           Hello MakingDevs
           """
  end

  test "GET /projects" do
    request = """
    GET /projects HTTP/1.1
    Host: makingdevs.com
    User-Agent: MyBrowser/0.1
    Accept: */*

    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Content-Type: text/html
           Content-Lenght: 22

           Traefik, Agora, Domino
           """
  end

  test "GET /developers/1" do
    request = """
    GET /developers/1 HTTP/1.1
    Host: makingdevs.com
    User-Agent: MyBrowser/0.1
    Accept: */*

    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Content-Type: text/html
           Content-Lenght: 17

           Hello developer 1
           """
  end

  test "GET /bugme" do
    request = """
    GET /bugme HTTP/1.1
    Host: makingdevs.com
    User-Agent: MyBrowser/0.1
    Accept: */*

    """

    response = Traefik.Handler.handle(request)

    assert response == """
           HTTP/1.1 404 Not found
           Content-Type: text/html
           Content-Lenght: 17

           No '/bugme' found
           """
  end

  test "GET /internal-projects" do
    request = """
    GET /internal-projects HTTP/1.1
    Host: makingdevs.com
    User-Agent: MyBrowser/0.1
    Accept: */*

    """

    response = Traefik.Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Content-Type: text/html
           Content-Lenght: 30

           Training for OTP, LiveView, Nx
           """
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1
    Host: makingdevs.com
    User-Agent: MyBrowser/0.1
    Accept: */*

    """

    response = Traefik.Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Content-Type: text/html
           Content-Lenght: 559

           <!DOCTYPE html>
           <html lang="en">
           <head>
             <meta charset="UTF-8">
             <title>Title</title>
           </head>
           <body>
           Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse aliquam, odio et condimentum placerat, est mi laoreet felis, non placerat lorem orci at quam. Nulla nibh nulla, dapibus sed erat pellentesque, lacinia cursus sem. Phasellus suscipit ac libero at malesuada. Aliquam et accumsan justo, rhoncus lacinia nisi. Mauris quis dui et massa commodo congue porta et turpis. Proin vitae semper sem, vel viverra magna. Nulla facilisi.
           </body>
           </html>

           """
  end

  test "POST /developers" do
    request = """
    POST /developers HTTP/1.1
    Host: makingdevs.com
    User-Agent: MyBrowser/0.1
    Accept: */*
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 44

    name=Juan&lastname=Reyes&email=juan@makingdevs.com
    """

    response = Traefik.Handler.handle(request)

    assert response == """
           HTTP/1.1 201 Created
           Content-Type: text/html
           Content-Lenght: 47

           Created dev: Juan - Reyes - juan@makingdevs.com
           """
  end

  test "GET /makingdevs" do
    request = """
    GET /makingdevs HTTP/1.1
    Host: makingdevs.com
    User-Agent: MyBrowser/0.1
    Accept: */*

    """

    response = Traefik.Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Content-Type: text/html
           Content-Lenght: 212

           <h1>Making Devs Developers</h1>
           <h2> Welcome!! </h2>
           <ul>

           <li>33 Dottie Avent Polygender<li>

           <li>29 Boris Belasco Polygender<li>

           <li>22 Merrile Clardge Polygender<li>

           <li>78 Warde Kubik Polygender<li>

           </ul>

           """
  end

  test "GET /makingdevs/3" do
    request = """
    GET /makingdevs/3 HTTP/1.1
    Host: makingdevs.com
    User-Agent: MyBrowser/0.1
    Accept: */*

    """

    response = Traefik.Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Content-Type: text/html
           Content-Lenght: 118

           <h1>MakingDevs Developer Profile</h1>
           <h2>3 Viki</h2>
           <h3>Van Halle</h3>
           <h3>Female</h3>
           <h4>Extra salary: false</h4>

           """
  end

  test "GET /api/developers" do
    request = """
    GET /api/developers HTTP/1.1
    Host: makingdevs.com
    User-Agent: MyBrowser/0.1
    Accept: */*
    Content-Type: application/json

    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Content-Type: application/json
           Content-Lenght: 390

           [{\"email\":\"jrubertis0@nytimes.com\",\"first_name\":\"Jerri\",\"gender\":\"Male\",\"id\":1,\"ip_address\":\"206.67.100.126\",\"last_name\":\"Rubertis\"},{\"email\":\"lgepson1@amazon.com\",\"first_name\":\"Lief\",\"gender\":\"Male\",\"id\":2,\"ip_address\":\"235.91.3.49\",\"last_name\":\"Gepson\"},{\"email\":\"vvanhalle2@quantcast.com\",\"first_name\":\"Viki\",\"gender\":\"Female\",\"id\":3,\"ip_address\":\"53.76.94.126\",\"last_name\":\"Van Halle\"}]
           """
  end
end
