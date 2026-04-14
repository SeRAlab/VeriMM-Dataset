`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x;
    wire [31:0] y1;
    wire [31:0] y2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y1(y1),
        .y2(y2)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: x = 0 (Boundary Check)", test_num);
        x = Q_ZERO;

        #1;


        check_outputs(32'h00010000, LN_ERROR);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: x = 1.0 (Standard Check)", test_num);
        x = Q_ONE;

        #1;


        check_outputs(32'h0002B7E1, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: x = -1.0 (Negative Input for ln)", test_num);
        x = -Q_ONE;

        #1;


        check_outputs(32'h00005E34, LN_ERROR);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: x = 2.0 (Range Check)", test_num);
        x = 32'h00020000;

        #1;


        check_outputs(32'h00076399, 32'h0000B172);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: x = Minimum signed integer (Extreme Negative)", test_num);
        x = 32'h80000000;

        #1;


        check_outputs(32'h00000000, LN_ERROR);
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
        input [31:0] expected_y1;
        input [31:0] expected_y2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2)) begin
                $display("PASS");
                $display("  Outputs: y1=%h, y2=%h",
                         y1, y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y1=%h, y2=%h",
                         expected_y1, expected_y2);
                $display("  Got:      y1=%h, y2=%h",
                         y1, y2);
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
