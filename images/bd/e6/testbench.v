`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [1:0] x;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            $display("Test Case 001: Enable low, x=00");
            enable = 0;
            x = 2'b00;
            #10;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Enable low, x=11");
            enable = 0;
            x = 2'b11;
            #10;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Enable high, x=00");
            enable = 1;
            x = 2'b00;
            #10;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Enable high, x=01");
            enable = 1;
            x = 2'b01;
            #10;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Enable high, x=10");
            enable = 1;
            x = 2'b10;
            #10;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Enable high, x=11");
            enable = 1;
            x = 2'b11;
            #10;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Toggle Enable low, x=10");
            enable = 0;
            x = 2'b10;
            #10;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Toggle Enable high again, x=01");
            enable = 1;
            x = 2'b01;
            #10;
            #1;

            check_outputs(4'b0010);
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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

endmodule
