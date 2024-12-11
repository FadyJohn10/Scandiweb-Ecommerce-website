<?php

header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Access-Control-Allow-Origin: *');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header("HTTP/1.1 200 OK");
    exit;
}

require_once __DIR__ . '/../server/vendor/autoload.php';

define('root_dir', dirname(__DIR__) . '/');

Dotenv\Dotenv::createImmutable(root_dir)->load();

include_once root_dir . 'server/src/Utils/helpers.php';

$dispatcher = FastRoute\simpleDispatcher(function (FastRoute\RouteCollector $r) {
    $r->post('/graphql', [App\GraphQL\Controller::class, 'handle']);
});

$routeInfo = $dispatcher->dispatch(
    $_SERVER['REQUEST_METHOD'],
    $_SERVER['REQUEST_URI']
);

handleRoute($routeInfo);

function handleRoute($routeInfo)
{
    switch ($routeInfo[0]) {
        case FastRoute\Dispatcher::NOT_FOUND:
            handleNotFound();
            break;
        case FastRoute\Dispatcher::METHOD_NOT_ALLOWED:
            handleMethodNotAllowed($routeInfo[1]);
            break;
        case FastRoute\Dispatcher::FOUND:
            handleFound($routeInfo[1], $routeInfo[2]);
            break;
    }
}

function handleNotFound()
{
    if (preg_match('/\.(?:css|js|png|jpg|jpeg|gif|ico)$/', $_SERVER['REQUEST_URI'])) {
        setMimeType($_SERVER['REQUEST_URI']);
        readfile(root_dir('public' . $_SERVER['REQUEST_URI']));
        exit;
    }

    require(root_dir('public/index.html'));
}

function handleMethodNotAllowed($allowedMethods)
{
    header('HTTP/1.1 405 Method Not Allowed');
    header('Allow: ' . implode(', ', $allowedMethods));
    exit;
}

function handleFound($handler, $vars)
{
    echo $handler($vars);
}

function setMimeType($filename)
{
    $mime_types = [
        'css' => 'text/css',
        'js' => 'application/javascript',
        'png' => 'image/png',
        'jpg' => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'gif' => 'image/gif',
        'ico' => 'image/x-icon',
    ];

    $ext = pathinfo($filename, PATHINFO_EXTENSION);

    if (array_key_exists($ext, $mime_types)) {
        header('Content-Type: ' . $mime_types[$ext]);
    } else {
        header('Content-Type: application/octet-stream');
    }
}