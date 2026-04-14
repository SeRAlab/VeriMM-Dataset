`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] value;
    wire [2:0] out0;
    wire [2:0] out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .value(value),
        .out0(out0),
        .out1(out1)
    );
    task testcase001;

    begin
        $display("Test Case 001: value = 00");
        test_num = 1;
        value = 2'b00;

        #1;


        check_outputs(3'd3, 3'd3);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: value = 01");
        test_num = 2;
        value = 2'b01;

        #1;


        check_outputs(3'd2, 3'd2);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: value = 10");
        test_num = 3;
        value = 2'b10;

        #1;


        check_outputs(3'd1, 3'd1);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: value = 11");
        test_num = 4;
        value = 2'b11;



        #1;




        check_outputs(3'd1, 3'd1);
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
        input [2:0] expected_out0;
        input [2:0] expected_out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%h",
                         out0, out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%h",
                         expected_out0, expected_out1);
                $display("  Got:      out0=%h, out1=%h",
                         out0, out1);
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
