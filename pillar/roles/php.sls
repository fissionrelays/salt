php:
  version: 7.4

  config:
    date_timezone: America/Chicago
    error_reporting: 'E_ALL & ~E_NOTICE & ~E_STRICT'
    expose_php: 'Off'
    max_input_vars: 3000
    max_execution_time: 180
    memory_limit: 384M
    session_gc_maxlifetime: 5400
    post_max_size: 20M
    upload_max_filesize: 20M

  extensions:
    - bcmath
    - cli
    - curl
    - imap
    - intl
    - json
    - mbstring
    - mysql
    - gd
    - soap
    - sqlite3
    - tidy
    - xml
    - zip
