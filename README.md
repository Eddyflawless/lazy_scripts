# lazy_scripts

* * * * * cd /var/www/hmtl/laravel-app && php artisan schedule:run >> /dev/null 2>&1

#certbot renew ssl certificates each day at 06:47
47 6 * * * certbot renew --post-hook "systemctl reload nginx"