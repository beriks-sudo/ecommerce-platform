<?php
// Health endpoint: готовность приложения = его зависимости (MySQL, Redis) доступны по сети.
// Возвращает 200, только если app может достучаться до обоих; иначе 503.
// Проверяем доступность портов через сокет — не требует PHP-расширений (pdo_mysql и т.п.).
// Healthcheck в compose дергает этот URL, Docker смотрит на HTTP-код через curl -f.

function tcp_ready(string $host, int $port, float $timeout = 2.0): bool {
    $conn = @fsockopen($host, $port, $errno, $errstr, $timeout);
    if ($conn === false) {
        return false;
    }
    fclose($conn);
    return true;
}

$checks = [
    'mysql' => tcp_ready(getenv('DB_HOST') ?: 'mysql', 3306),
    'redis' => tcp_ready(getenv('REDIS_HOST') ?: 'redis', 6379),
];

$failed = array_keys(array_filter($checks, fn ($ok) => $ok === false));

if ($failed === []) {
    http_response_code(200);
    echo 'ok';
} else {
    http_response_code(503); // не готов → curl -f вернёт ненулевой код → unhealthy
    echo 'unhealthy: unreachable ' . implode(', ', $failed);
}
