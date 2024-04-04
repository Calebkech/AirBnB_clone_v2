# Define the Nginx configuration
$nginx_conf = "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By ${hostname};
    root   /var/www/html;
    index  index.html index.htm;

    location /hbnb_static {
        alias /data/web_static/current;
        index index.html index.htm;
    }

    location /redirect_me {
        return 301 http://cuberule.com/;
    }

    error_page 404 /404.html;
    location /404 {
      root /var/www/html;
      internal;
    }
}"

# Install Nginx package
package { 'nginx':
  ensure   => 'present',
  provider => 'apt'
} ->

# Create necessary directories
file { '/data':
  ensure  => 'directory'
} ->

file { '/data/web_static':
  ensure => 'directory'
} ->

file { '/data/web_static/releases':
  ensure => 'directory'
} ->

file { '/data/web_static/releases/test':
  ensure => 'directory'
} ->

file { '/data/web_static/shared':
  ensure => 'directory'
} ->

# Create a sample index.html file in /data/web_static/releases/test
file { '/data/web_static/releases/test/index.html':
  ensure  => 'present',
  content => "<html>\n  <head>\n  </head>\n  <body>\n    Holberton School\n  </body>\n</html>\n"
} ->

# Create a symbolic link to point to the current release
file { '/data/web_static/current':
  ensure => 'link',
  target => '/data/web_static/releases/test'
} ->

# Ensure ownership is set to ubuntu:ubuntu
exec { 'chown -R ubuntu:ubuntu /data/':
  path => '/usr/bin/:/usr/local/bin/:/bin/'
}

# Ensure /var/www/html exists
file { '/var/www':
  ensure => 'directory'
} ->

file { '/var/www/html':
  ensure => 'directory'
} ->

# Create a default index.html in /var/www/html
file { '/var/www/html/index.html':
  ensure  => 'present',
  content => "<html>\n  <head>\n  </head>\n  <body>\n    Holberton School Nginx\n  </body>\n</html>\n"
} ->

# Create a 404.html in /var/www/html
file { '/var/www/html/404.html':
  ensure  => 'present',
  content => "<html>\n  <head>\n  </head>\n  <body>\n    Ceci n'est pas une page\n  </body>\n</html>\n"
} ->

# Apply the Nginx configuration
file { '/etc/nginx/sites-available/default':
  ensure  => 'present',
  content => $nginx_conf
} ->

# Restart Nginx service
exec { 'nginx restart':
  path => '/etc/init.d/'
}
