`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [1:0] select;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            enable = 0;
            select = 2'b00;
            #10;
            $display("Test Case 001: Enable=0, Select=00");
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            enable = 1;
            select = 2'b00;
            #10;
            $display("Test Case 002: Enable=1, Select=00 (Output bit 0 active)");
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            enable = 1;
            select = 2'b01;
            #10;
            $display("Test Case 003: Enable=1, Select=01 (Output bit 1 active)");
            #1;

            check_outputs(16'hFFFD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            enable = 1;
            select = 2'b10;
            #10;
            $display("Test Case 004: Enable=1, Select=10 (Output bit 2 active)");
            #1;

            check_outputs(16'hFFFB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            enable = 1;
            select = 2'b11;
            #10;
            $display("Test Case 005: Enable=1, Select=11 (Output bit 3 active)");
            #1;

            check_outputs(16'hFFF7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            enable = 1;
            select = 2'b10;
            #5;
            enable = 0;
            #5;
            $display("Test Case 006: Toggle Enable Low (Select was 10)");
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            enable = 1;
            select = 2'b00; #2;
            select = 2'b11; #2;
            select = 2'b01;
            #10;
            $display("Test Case 007: Rapid transition to Select=01");
            #1;

            check_outputs(16'hFFFD);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
