<?php

if (!file_exists('.env')) {
    copy('.env.dist', '.env');
}

if (file_exists('public/.gitignore')) {
    unlink('public/.gitignore');
}

if (file_exists('README_project.md')) {
    rename('README_project.md', 'README.md');
}

