`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] code_in;
    wire [3:0] code_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .code_in(code_in),
        .code_out(code_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: code_in = 2'b00");
        code_in = 2'b00;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: code_in = 2'b01");
        code_in = 2'b01;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: code_in = 2'b10");
        code_in = 2'b10;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: code_in = 2'b11");
        code_in = 2'b11;
        #1;

        check_outputs(4'b1000);
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
        input [3:0] expected_code_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h",
                         code_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h",
                         expected_code_out);
                $display("  Got:      code_out=%h",
                         code_out);
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
