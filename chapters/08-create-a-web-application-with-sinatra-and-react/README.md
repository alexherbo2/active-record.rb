# Create a web application with Sinatra and React

###### [Previous chapter](../07-make-your-own-gem)

Now [active-record.rb] has been implemented,
we are going to use it to create a web application with [Sinatra] and [React].

[active-record.rb]: ../../gem
[Sinatra]: http://sinatrarb.com
[React]: https://reactjs.org

## Resources

- [Ruby Sinatra Starter]

[Ruby Sinatra Starter]: https://youtu.be/8aA9Enb8NVc

## Setup

Run the following in your terminal to install dependencies and setting up the database:

``` sh
make setup
```

Launch Sinatra:

``` sh
make serve
```

Open [`localhost:3000`].

[`localhost:3000`]: http://localhost:3000

## Server – Sinatra

[`server/server.rb`]:

``` ruby
require 'sinatra'
require 'active-record'
# [...]
require './app/models/pokemon'

get '/' do # ⇐ Router part
  content_type 'text/html'
  send_file '../client/index.html' # ⇐ Controller part
end

# REST API
#
# Example: curl localhost:3000/api/pokemons
get '/api/pokemons' do
  content_type 'application/json'
  Pokemon.all.to_json
end
```

## Client – React

[`client/index.html`]:

``` html
<!DOCTYPE html>
<html>
  <head>
    <!-- [...] -->
  </head>
  <body>
    <main></main>

    <!-- Load React -->
    <!-- https://reactjs.org/docs/add-react-to-a-website.html -->
    <script src="https://unpkg.com/react@17/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js" crossorigin></script>
    <script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
    <!-- Load application -->
    <script type="text/babel" src="app.js"></script>
  </body>
</html>
```

[`client/app.js`]:

``` jsx
const main = async () => {
  const pokemons = await fetch('/api/pokemons').then((response) => response.json())

  const component = (
    <section>
      <p>Hello, World!</p>
    </section>
  )

  // Render component
  ReactDOM.render(component, document.querySelector('main'))
}

main()
```

We are [using Fetch] to communicate with the server.

[Using Fetch]: https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch

## Debugging

Install [Byebug]:

``` sh
gem install byebug
```

[Byebug]: https://github.com/deivid-rodriguez/byebug

[`server/server.rb`]:

``` ruby
require 'byebug'

get '/pokemons/:pokemon_number' do
  byebug # code will stop here; inspect params.
end
```

## Challenge

Implement the four basic [CRUD] operations.

[CRUD]: https://en.wikipedia.org/wiki/Create,_read,_update_and_delete

### Quick start

Open [`server/server.rb`], [`client/index.html`] and [`client/app.js`].

[`server/server.rb`]: server/server.rb
[`client/index.html`]: client/index.html
[`client/app.js`]: client/app.js

## Sharing your web application

Share your work with [ngrok]:

``` sh
ngrok http 3000
```

[ngrok]: https://ngrok.com

## Solution

[Download solution].

[Download solution]: ../solved/08-create-a-web-application-with-sinatra-and-react
