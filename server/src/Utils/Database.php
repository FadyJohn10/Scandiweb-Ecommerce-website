<?php

namespace App\Utils;

use PDO;
use Exception;

class Database
{
    private PDO $conn;
    private $stmt;

    public function __construct()
    {
        $dbConfig = require root_dir('server/src/config/database.php') ?? [];
        $dsn = 'mysql:' . http_build_query($dbConfig, '', ';');

        $options = [
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        ];

        try {
            $this->conn = new PDO($dsn, null, null, $options);
        } catch (Exception $e) {
            abort(500, 'Database connection failed');
        }
    }

    public function query(string $query, array $params = []): self
    {
        $this->stmt = $this->conn->prepare($query);
        $this->stmt->execute($params);

        return $this;
    }

    public function get(): array
{
        return $this->stmt->fetchAll();
    }

    public function fetch(): array | false
    {
        return $this->stmt->fetch();
    }

    public function fetchOrFail(): array
    {
        $result = $this->fetch();

        if (!$result) {
            abort(404, 'Resource not found');
        }

        return $result;
    }

    public function fetchColumn(): mixed
    {
        return $this->stmt->fetchColumn();
    }

    public function getLastInsertId(): string
    {
        return $this->conn->lastInsertId();
    }

    public function beginTransaction(): bool
    {
        return $this->conn->beginTransaction();
    }

    public function commit(): bool
    {
        return $this->conn->commit();
    }

    public function rollback(): bool
    {
        return $this->conn->rollBack();
    }
}