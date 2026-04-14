`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] brightness;
    reg clock;
    wire driver;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .brightness(brightness),
        .clock(clock),
        .driver(driver)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            brightness = 0;

            repeat(256) @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            brightness = 8'd0;
            repeat(50) @(posedge clock);
            #1;
            $display("Testcase 001: Brightness = 0");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            brightness = 8'd255;

            repeat(10) @(posedge clock);
            #1;
            $display("Testcase 002: Brightness = 255, early in cycle (Counter < 255)");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            brightness = 8'd255;

            repeat(255) @(posedge clock);
            #1;
            $display("Testcase 003: Brightness = 255, end of cycle (Counter = 255)");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            brightness = 8'd128;
            repeat(64) @(posedge clock);
            #1;
            $display("Testcase 004: Brightness = 128, halfway through active phase");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            brightness = 8'd128;
            repeat(200) @(posedge clock);
            #1;
            $display("Testcase 005: Brightness = 128, in inactive phase");
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_driver;
        begin
            if (expected_driver === (expected_driver ^ driver ^ expected_driver)) begin
                $display("PASS");
                $display("  Outputs: driver=%b",
                         driver);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: driver=%b",
                         expected_driver);
                $display("  Got:      driver=%b",
                         driver);
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
        $dumpvars(0,brightness, clock, driver);
    end

endmodule
