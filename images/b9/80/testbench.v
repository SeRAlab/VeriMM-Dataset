`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_in;
    wire [6:0] seg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .seg_out(seg_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input 0");
        binary_in = 4'd0;
        #1;

        check_outputs(7'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input 1");
        binary_in = 4'd1;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input 2");
        binary_in = 4'd2;
        #1;

        check_outputs(7'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input 3");
        binary_in = 4'd3;
        #1;

        check_outputs(7'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input 4");
        binary_in = 4'd4;
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input 5");
        binary_in = 4'd5;
        #1;

        check_outputs(7'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Input 6");
        binary_in = 4'd6;
        #1;

        check_outputs(7'h7D);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Input 7");
        binary_in = 4'd7;
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Input 8");
        binary_in = 4'd8;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Input 9");
        binary_in = 4'd9;
        #1;

        check_outputs(7'h6F);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case 011: Invalid Input (10)");
        binary_in = 4'd10;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case 012: Invalid Input (15)");
        binary_in = 4'd15;
        #1;

        check_outputs(7'h00);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [6:0] expected_seg_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg_out === (expected_seg_out ^ seg_out ^ expected_seg_out)) begin
                $display("PASS");
                $display("  Outputs: seg_out=%h",
                         seg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_out=%h",
                         expected_seg_out);
                $display("  Got:      seg_out=%h",
                         seg_out);
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
