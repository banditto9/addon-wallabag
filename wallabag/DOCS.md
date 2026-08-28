# Home Assistant Add-on: Wallabag

Wallabag is a web application allowing you to save web pages for later reading.
Click, save and read it when you want. It extracts content so that you
won't be distracted by pop-ups and cie.

Further information can be found at [Wallabag].

## Installation

To install this add-on do the following steps:

1. On supervisor -> add-on go to the options and select Repositories.
1. Add the URL for apps/addons repo
   to the add text box and click on ADD.
1. Search for the "Wallabag" add-on in the add-on store and install it.
1. Start the "Wallabag" add-on.
1. Check the logs of the "Wallabag" add-on to see if everything went well.

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```yaml
log_level: info
ssl: false
certfile: fullchain.pem
keyfile: privkey.pem
twofactor_auth: true
anyone_can_register: false
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

Upon starting the add-on creates a default user with the following credentials:

```yaml
username: wallabag
password: wallabag
```

It is advised that as soon as you start the add-on you should change this user password.

### Option: `log_level`

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `warning`: Exceptional occurrences that are not errors.
- `error`: Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `ssl`

Enables/Disables SSL (HTTPS) on the web interface of Wallabag
Panel. Set it `true` to enable it, `false` otherwise.

**Note**: If set to true you need to configure the `app_url` option
to point to the https address so that the page loads correctly

### Option: `certfile`

The certificate file to use for SSL.

**Note**: _The file MUST be stored in `/ssl/`, which is the default._

### Option: `keyfile`

The private key file to use for SSL.

**Note**: _The file MUST be stored in `/ssl/`, which is the default._

### Option: `remote_mysql_host`

If using an external database, the hostname/address for the MYSQL/MariaDB
database.

### Option: `remote_mysql_database`

Only applies if a remote MYSQL database is used, the name of the database.

### Option: `remote_mysql_username`

Only applies if a remote MYSQL database is used, the username with permissions.

### Option: `remote_mysql_password`

Only applies if a remote MYSQL database is used, the password of the above user.

### Option: `remote_mysql_port`

Only applies if a remote MYSQL database is used, the port that the database
server is listening on.

### Option: `token_secret`

A secret key that's used to generate certain security-related tokens.
This is a string that should be unique to your application and it's
commonly used to add more entropy to security related operations.

### Option: `app_url`

Full URL of your wallabag instance (without the trailing slash).
For example `https://wallabag.example.com`.
If you enabled ssl you are going to need to set up this option with the https address
for the page to load correctly.

### Option: `app_name`

The name that will appear on the main HTML page. For example `Your wallabag instance`

### Option: `locale`

Default language of your wallabag instance (like en, fr, es, etc.).
Rigth now only has been tested with `en`

### Option: `twofactor_auth`

Enable or disable two factor authentication. For more information check [Wallabag-user-docs]

### Option: `twofactor_sender`

Sender email address to receive the two factor code.
For more information check [Wallabag-user-docs]

### Option: `anyone_can_register`

Set to _true_ to enable public registration. Default is false

**Note**: _Setting this to true will allow anyone with access
to your site to register an account_

### Option: `fosuser_confirmation`

Set to _true_ to send a confirmation by email for each registration.
Default is _false_

## Registering and managing users

When the option `anyone_can_register` is set to _false_ the front page will not
display a `Register` button. The only way to create new users is loggin in with
an admin user and adding a new one under My Account -> users.
The default wallabag user has admin priviledges.

When the option `anyone_can_register` is set to _true_ the front page will
display a `Register` button. You can use this button to register new users.
You can have some control on the registrations by setting `fosuser_confirmation`
to _true_ and receive confimation requests by email each time a new user registers.

## Database usage

By default, Wallabag will automatically use and configure the Home Assistant
MariaDB addon which should be installed prior to startup, this can be changed
within the configuration to use an external MySql/MariaDB Database. Please note
that there is no easy upgrade path between the two options.

## Known issues and limitations

When SSL is turned on it setting requires setting `app_url` with the https address
so that the page loads correctly. Failing to do this will make the site unable to
load css and javascripts correctly.

The same is true when setting a reverse proxy. `app_url` must be set with
the https address of the reverse proxy.


## Authors & contributors

The original setup of this repository is by [Paulo Costa][coostax].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

[wallabag]: https://wallabag.org/
[wallabag-user-docs]: https://doc.wallabag.org/en/user/configuration/user_information.html
