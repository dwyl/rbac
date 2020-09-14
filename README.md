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






### Usage

Once you have added the 




API/Function reference available at
[https://hexdocs.pm/rbac](https://hexdocs.pm/rbac).


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
