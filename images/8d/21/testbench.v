`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_in;
    wire [1:0] binary_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .binary_out(binary_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: binary_in = 0");
        binary_in = 4'd0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: binary_in = 1");
        binary_in = 4'd1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: binary_in = 2");
        binary_in = 4'd2;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: binary_in = 3");
        binary_in = 4'd3;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: binary_in = 4 (Boundary check, expected default)");
        binary_in = 4'd4;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: binary_in = 7 (Middle range check, expected default)");
        binary_in = 4'd7;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: binary_in = 12 (Random high value check)");
        binary_in = 4'd12;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: binary_in = 15 (Max value boundary check)");
        binary_in = 4'd15;
        #1;

        check_outputs(2'b00);
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
        input [1:0] expected_binary_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_out === (expected_binary_out ^ binary_out ^ expected_binary_out)) begin
                $display("PASS");
                $display("  Outputs: binary_out=%h",
                         binary_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_out=%h",
                         expected_binary_out);
                $display("  Got:      binary_out=%h",
                         binary_out);
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
