**v1.0 ~ v1.0.3**
- v1.0.3 - database_charset changed to utf8mb4 as per wallabag docs (emoji etc)
- v1.0.2 - increase max_execution_time value to 300s (5 minutes) for large imports and slow machines (default value of 30s caused issues importing more than 500 articles at once)
- v1.0.1 - corrected import (tested with Intapaper csv), previously it gave /uploads folder permission error
- Wallabag 2.6.14
- Debian 13 (trixie) base image 9.4.0
- PHP 8.3 as 8.4 seems to have some issues with Wallabag
- NodeJS 2x from base image
- Environment software versions added to the log output for troubleshooting if any required
- (!)NB: For clean installations: MariaDB requires manual user creation (with some password), 'wallabag' db creation and addition of created user priviliges to the 'wallabag' DB, then use wallabag app/add-on as a remote connection
