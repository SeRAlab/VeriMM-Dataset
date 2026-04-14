`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] COUNTER_in;
    wire [15:0] INSTR_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .COUNTER_in(COUNTER_in),
        .INSTR_out(INSTR_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Counter = 0");
        COUNTER_in = 4'd0;



        #1;




        check_outputs(16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Counter = 1");
        COUNTER_in = 4'd1;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Counter = 2");
        COUNTER_in = 4'd2;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Counter = 8");
        COUNTER_in = 4'd8;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Counter = 15 (Potential Default Case)");
        COUNTER_in = 4'd15;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_INSTR_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_INSTR_out === (expected_INSTR_out ^ INSTR_out ^ expected_INSTR_out)) begin
                $display("PASS");
                $display("  Outputs: INSTR_out=%h",
                         INSTR_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: INSTR_out=%h",
                         expected_INSTR_out);
                $display("  Got:      INSTR_out=%h",
                         INSTR_out);
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
