<?php

function root_dir($path){
    return root_dir . $path;
}

function abort($code, $message)
{
    http_response_code($code);
    header('Content-Type: application/json');

    $response = [
        'error' => $message
    ];

    echo json_encode($response);
    die();
}