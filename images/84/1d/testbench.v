`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] f;
    wire [5:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .f(f),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All zeros");
        f = 6'b000000;
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: All ones (Check 2-bit shift and 0-filling)");
        f = 6'b111111;
        #1;

        check_outputs(6'b001111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: MSB bits (110000 -> 001100)");
        f = 6'b110000;
        #1;

        check_outputs(6'b001100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: LSB bits (000011 -> 000000)");
        f = 6'b000011;
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Alternating bits (101010 -> 001010)");
        f = 6'b101010;
        #1;

        check_outputs(6'b001010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Single bit shift (000100 -> 000001)");
        f = 6'b000100;
        #1;

        check_outputs(6'b000001);
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
        input [5:0] expected_out;
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
