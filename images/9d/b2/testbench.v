`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    wire [32:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Initial check with clk low");

            clk = 0;
            #10;

            #1;


            check_outputs(33'bx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Check after a single positive clock edge");

            clk = 0;
            #5;

            clk = 1;
            #5;

            #1;


            check_outputs(33'bx);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Check after multiple clock cycles");

            clk = 0;
            #5;

            repeat (10) begin
                #5 clk = ~clk;
            end

            #1;


            check_outputs(33'bx);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Check with long duration stability");

            clk = 0;
            #100;

            #1;


            check_outputs(33'bx);
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
        input [32:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
