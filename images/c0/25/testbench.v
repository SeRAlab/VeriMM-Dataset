`timescale 1ns/1ps

module uart_clock_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    wire uart_tick;
    wire uart_tick_16x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_clock dut (
        .clock(clock),
        .uart_tick(uart_tick),
        .uart_tick_16x(uart_tick_16x)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_clock Testbench");
        $display("========================================");


        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_uart_tick;
        input expected_uart_tick_16x;
        begin
            if (expected_uart_tick === (expected_uart_tick ^ uart_tick ^ expected_uart_tick) &&
                expected_uart_tick_16x === (expected_uart_tick_16x ^ uart_tick_16x ^ expected_uart_tick_16x)) begin
                $display("PASS");
                $display("  Outputs: uart_tick=%b, uart_tick_16x=%b",
                         uart_tick, uart_tick_16x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: uart_tick=%b, uart_tick_16x=%b",
                         expected_uart_tick, expected_uart_tick_16x);
                $display("  Got:      uart_tick=%b, uart_tick_16x=%b",
                         uart_tick, uart_tick_16x);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clock, uart_tick, uart_tick_16x);
    end

endmodule
