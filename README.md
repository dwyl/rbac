<div align="center">

# `rbac`

Role Based Access Control (**`RBAC`**) gives you
a human-friendly way of controlling access
to specific data/features in your App(s).

[![Build Status](https://img.shields.io/travis/com/dwyl/rbac/master.svg?style=flat-square)](https://travis-ci.com/dwyl/rbac)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/rbac/master.svg?style=flat-square)](http://codecov.io/github/dwyl/rbac?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/rbac?color=brightgreen&style=flat-square)](https://hex.pm/packages/rbac)
[![Libraries.io dependency status](https://img.shields.io/librariesio/release/hex/rbac?logoColor=brightgreen&style=flat-square)](https://libraries.io/hex/rbac)
[![docs](https://img.shields.io/badge/docs-maintained-brightgreen?style=flat-square)](https://hexdocs.pm/rbac/api-reference.html)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/rbac/issues)
[![HitCount](http://hits.dwyl.io/dwyl/rbac.svg)](http://hits.dwyl.io/dwyl/rbac)

</div>



## Why?

You want an _easy_ way to restrict access to features fo your Elixir/Phoenix App
based on a sane model of roles.
**`RBAC`** lets you _easily_ manage roles and permissions in any application
and see at a glance exactly which permissions a person has in the system.
It reduces complexity over traditional
Access Control List (ACL) based permissions systems.



## What?

The purpose of **`RBAC`** is to provide a framework
for application administrators and developers
to manage the permissions assigned to the people using the App(s).



## Who?

Anyone who is interested in developing secure applications
used by many people with differing needs and permissions
should learn about **`RBAC`**.


## _How_?


### Installation

Install by adding `rbac` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rbac, "~> 0.3.0"}
  ]
end
```

### Setup

Open the `application.ex` file of your project 
and locate the `def start(_type, _args) do` definition, e.g:

```elixir
def start(_type, _args) do
  # List all child processes to be supervised
  children = [
    # Start the Ecto repository
    Auth.Repo,
    # Start the endpoint when the application starts
    {Phoenix.PubSub, name: Auth.PubSub},
    AuthWeb.Endpoint
    # Starts a worker by calling: Auth.Worker.start_link(arg)
    # {Auth.Worker, arg},
  ]

  # See https://hexdocs.pm/elixir/Supervisor.html
  # for other strategies and supported options
  opts = [strategy: :one_for_one, name: Auth.Supervisor]
  Supervisor.start_link(children, opts)
end
```

Add the following code at the top of the function definition:

```elixir
# initialize RBAC Cache:
RBAC.init_roles_cache(
  "https://dwylauth.herokuapp.com",
  AuthPlug.Token.client_id()
)
```


### Usage

Once you have added the initialization code,
you can easily check that a person has a required role 
using the following code:

```elixir
RBAC.has_role?(conn, "admin")
> true
```

Or if you want to check that the person has has any role in a list of potential roles:

```elixir
RBAC.has_role_any?(conn, ["admin", "commenter"])
> true
```

We prefer to make our code as declarative and human-friendly as possible,
hence the `String` role names. 
However both the role-checking functions also accept a list of integers,
corresponding to the `role.id` of the required role, e.g:

```elixir
RBAC.has_role?(conn, 2)
> true
```

If the person does not have the **`superadmin`** role,
`has_role?/2` will return `false`

```elixir
RBAC.has_role?(conn, 1)
> false
```

Or supply a list of integers to `has_role_any?/2` if you prefer:

```elixir
RBAC.has_role_any?(conn, [1,2,3])
> true
```

You can even _mix_ the type in the list:

```elixir
RBAC.has_role_any?(conn, ["admin",2,3])
> true
```

But we recommend picking one, and think advise using strings for code legibility.
e.g:

```elixir
RBAC.has_role?(conn, "building_admin") 
```

Is very clear which role is required.
Whereas using an `int` (_especially for custom roles_) is a bit more terse:

```elixir
RBAC.has_role?(conn, 13) 
```

It requires the developer/code reviewer/maintainer 
to either know what the role is,
or look it up in a list. 




API/Function reference available at
[https://hexdocs.pm/rbac](https://hexdocs.pm/rbac).

<!--
## Trouble Shooting

If your app does not have a valid `AUTH_API_KEY` you may see the following error:

```
Generated auth app
** (Mix) Could not start application auth: exited in: Auth.Application.start(:normal, [])
    ** (EXIT) an exception was raised:
        ** (Protocol.UndefinedError) protocol Enumerable not implemented for "Internal Server Error" of type BitString. This protocol is implemented for the following type(s): Ecto.Adapters.SQL.Stream, Postgrex.Stream, DBConnection.PrepareStream, DBConnection.Stream, StreamData, IO.Stream, Map, Date.Range, List, GenEvent.Stream, HashSet, MapSet, Range, HashDict, Function, Stream, File.Stream
            (elixir 1.10.4) lib/enum.ex:1: Enumerable.impl_for!/1
            (elixir 1.10.4) lib/enum.ex:141: Enumerable.reduce/3
            (elixir 1.10.4) lib/enum.ex:3383: Enum.map/2
            (rbac 0.4.0) lib/rbac.ex:69: RBAC.parse_body_response/1
            (rbac 0.4.0) lib/rbac.ex:88: RBAC.init_roles_cache/2
            (auth 1.2.4) lib/auth/application.ex:9: Auth.Application.start/2
            (kernel 7.0) application_master.erl:277: :application_master.start_it_old/4
The command "mix ecto.setup" failed and exited with 1 during .
```

Simply follow the instructions to get your `AUTH_API_KEY` and export it as an environment variable.
-->

<br /><br />

## tl;dr > RBAC Knowledge Summary


Each role granted just enough flexibility and permissions
to perform the tasks required for their job,
this helps enforce the
[principal of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege)

The RBAC methodology is based on a set of three principal rules
that govern access to systems:

1. **Role Assignment**:
Each transaction or operation can only be carried out
if the person has assumed the appropriate role.
An operation is defined as any action taken
with respect to a system or network object that is protected by RBAC.
Roles may be assigned by a separate party
or selected by the person attempting to perform the action.

2. **Role Authorization**:
The purpose of role authorization
is to ensure that people can only assume a role
for which they have been given the appropriate authorization.
When a person assumes a role,
they must do so with authorization from an administrator.

3. **Transaction Authorization**:
An operation can only be completed
if the person attempting to complete the transaction
possesses the appropriate role.



## Recommended Reading

+ https://en.wikipedia.org/wiki/Role-based_access_control
+ https://www.sumologic.com/glossary/role-based-access-control
+ https://medium.com/@adriennedomingus/role-based-access-control-rbac-permissions-vs-roles-55f1f0051468
