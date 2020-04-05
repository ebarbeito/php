<?php

declare(strict_types=1);

namespace Ebarbeito\Php\Test\Functional;

use PHPUnit\Framework\TestCase;

final class DummyFunctionalSuiteTest extends TestCase
{
    public function test_functional_dummy(): void
    {
        $this->assertTrue(true);
    }
}