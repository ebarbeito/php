<?php

declare(strict_types=1);

namespace Ebarbeito\Php\Test\Integration;

use PHPUnit\Framework\TestCase;

class DummyIntegrationSuiteTest extends TestCase
{
    public function test_integration_dummy(): void
    {
        $this->assertTrue(true);
    }
}