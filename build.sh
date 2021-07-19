#!/usr/bin/env bash

# PHP=/usr/local/Cellar/php@7.2/7.2.34_4/bin/php
PHP=/usr/local/Cellar/php/8.0.7/bin/php

echo "⇒ Fetching new Standard Project stuff 🌬"

git pull
$PHP /usr/local/bin/composer update

$PHP bin/console bolt:copy-themes

composer show | grep bolt