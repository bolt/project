#!/usr/bin/env bash

PHP=/usr/local/Cellar/php@7.2/7.2.30_1/bin/php

echo "⇒ Fetching new Standard Project stuff 🌬"

git pull
$PHP /usr/local/bin/composer update
$PHP bin/console bolt:copy-themes

echo "⇒ Building assets 🌬"

make build-assets
make copy-assets
