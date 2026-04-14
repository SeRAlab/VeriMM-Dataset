`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in0;
    wire [5:0] out0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .out0(out0)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase 001: Setting in0 to 0 (Expecting ident1)");

            in0 = 1'b0;

            #10;

            #1;


            check_outputs(6'h20);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase 002: Setting in0 to 1 (Expecting ident0)");
            in0 = 1'b1;
            #10;

            #1;


            check_outputs(6'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase 003: Transitioning in0 from 1 to 0");
            in0 = 1'b1;
            #5;
            in0 = 1'b0;
            #10;
            #1;

            check_outputs(6'h20);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase 004: Transitioning in0 from 0 to 1");
            in0 = 1'b0;
            #5;
            in0 = 1'b1;
            #10;
            #1;

            check_outputs(6'h15);
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
        input [5:0] expected_out0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0)) begin
                $display("PASS");
                $display("  Outputs: out0=%h",
                         out0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h",
                         expected_out0);
                $display("  Got:      out0=%h",
                         out0);
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
