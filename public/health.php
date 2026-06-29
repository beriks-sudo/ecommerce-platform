<?php
// Health endpoint: готовность приложения = оно реально может работать со своими
// зависимостями. Проверяем НЕ просто открытый порт, а живой ответ сервиса:
//   - MySQL: выполняем запрос SELECT 1 через PDO;
//   - Redis: посылаем PING и ждём +PONG.
// Возвращает 200 только если обе проверки прошли, иначе 503.
// Healthcheck в compose дергает этот URL, Docker смотрит на HTTP-код через curl -f.

$errors = [];

// --- MySQL: реальный запрос ---
try {
    $pdo = new PDO(
        'mysql:host=' . (getenv('DB_HOST') ?: 'mysql')
            . ';dbname=' . (getenv('DB_DATABASE') ?: 'ecommerce'),
        getenv('DB_USERNAME') ?: 'ecommerce',
        getenv('DB_PASSWORD') ?: 'ecommerce_password',
        [PDO::ATTR_TIMEOUT => 2, PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
    $pdo->query('SELECT 1')->fetchColumn();
} catch (Throwable $e) {
    $errors[] = 'mysql: ' . $e->getMessage();
}

// --- Redis: реальный PING/PONG ---
try {
    $conn = @fsockopen(getenv('REDIS_HOST') ?: 'redis', 6379, $errno, $errstr, 2);
    if ($conn === false) {
        throw new RuntimeException($errstr ?: 'connection failed');
    }
    fwrite($conn, "PING\r\n");
    $reply = fgets($conn);
    fclose($conn);
    if (strpos((string) $reply, 'PONG') === false) {
        throw new RuntimeException('unexpected reply: ' . trim((string) $reply));
    }
} catch (Throwable $e) {
    $errors[] = 'redis: ' . $e->getMessage();
}

if ($errors === []) {
    http_response_code(200);
    echo 'ok';
} else {
    http_response_code(503); // не готов → curl -f вернёт ненулевой код → unhealthy
    echo 'unhealthy: ' . implode('; ', $errors);
}
