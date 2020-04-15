# Composer image for development

This image is based on the official [composer:1.10](https://hub.docker.com/_/composer) one.

It adds the following things:

* Composer plugin `hirak/prestissimo` (downloads packages in parallel to speed up installing dependencies)
