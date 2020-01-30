<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Bolt - Installation error</title>
    <style>
        body{font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;color:#333;font-size:16px;line-height:24px;margin:0;}
        h1 {font-size: 38.5px;line-height: 40px;margin: 2rem 0;}
        p{margin: 1rem 0;}
        strong{font-weight:bold;}
        code, pre {padding: 0 3px 2px;font-family: Monaco,Menlo,Consolas,"Courier New",monospace;font-size: 12px;color: #333;border-radius: 3px;}
        pre { display: block; white-space: pre-wrap; color: #D14;background-color: #F7F7F9;border: 1px solid #E1E1E8; }
        code {padding: 2px 4px;color: #D14;background-color: #F7F7F9;border: 1px solid #E1E1E8; white-space: nowrap;}
        a {color: #08C;text-decoration: none;}
        ul, ol {padding: 0;margin: 0 0 10px 25px;}
        hr{margin:20px 0;border:0;border-top:1px solid #eeeeee;border-bottom:1px solid #ffffff;}
        .hide{display:none;}
    </style>
</head>
<body style="padding: 20px;">

<div style="max-width: 640px; margin: auto;">

    <h1>Bolt - Installation error</h1>

    <p><strong>If you can read this, you've (probably) installed Bolt in the wrong folder.</strong></p>

    <p>
        It's recommended to install Bolt outside the so-called web root, because
        this is generally seen as 'best practice', and it is good for overall
        security. The reason you are seeing this page, is that your web server
        is currently serving the incorrect folder as 'web root'. Or, to put it
        the other way around: This file should not be visible.
    </p>

    <p>
        The current folder is: <code><?php echo getcwd(); ?>/</code>.
    </p>
    <p>
        The best and easiest fix is to configure the server to use
        this 'document root':<br>

        <code><?php echo getcwd(); ?>/public/</code> .
    </p>
    <hr>

    <p>
        Alternatively, move everything 'up' one level. So instead of extracting
        the <code>.zip</code> or <code>.tgz</code> file in this folder, extract
        it in <code><?php echo dirname(getcwd()); ?>/</code> instead.
    </p>

    <hr>

    <p>
        If you're having troubles, please consult the documentation on
        <a href="https://docs.bolt.cm/installation/installation">Installing Bolt</a>,
        as well as the page on
        <a href="https://docs.bolt.cm/howto/troubleshooting-outside-webroot">
            Troubleshooting 'Outside of the web root'
        </a>.
    </p>


    <ul>
        <li>
            <a href="https://docs.bolt.cm/installation/installation">
                <span class="hide"> * https://docs.bolt.cm/installation/installation - </span>
                Bolt documentation - Setup / Installation
            </a>
        </li>
        <li>
            <a href="https://docs.bolt.cm/howto/troubleshooting-outside-webroot">
                <span class="hide"> * https://docs.bolt.cm/howto/troubleshooting-outside-webroot - </span>
                Bolt documentation - Troubleshooting 'Outside of the web root'
            </a>
        </li>
        <li>
            <a href="https://discuss.bolt.cm/">
                <span class="hide"> * https://discuss.bolt.cm/ - </span>
                The Bolt discussion forum
            </a>
        </li>
        <li>
            <a href="https://bolt.cm/community">
                <span class="hide"> * https://bolt.cm/community - </span>
                IRC, Slack or Twitter - Bolt Community
            </a>
        </li>
    </ul>

</div>
<hr>

</body>
</html>
