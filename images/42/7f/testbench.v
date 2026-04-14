`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg s;
    reg [3:0] x;
    wire [6:0] a_to_g;
    wire [3:0] an;
    wire dp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s(s),
        .x(x),
        .a_to_g(a_to_g),
        .an(an),
        .dp(dp)
    );
    task testcase001;

    begin
        $display("Testcase 001: x=0 (Hex 0), s=0");
        test_num = 1;
        x = 4'd0;
        s = 1'b0;

        #1;


        check_outputs(7'b1111110, 4'b1110, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: x=5 (Hex 5), s=0");
        test_num = 2;
        x = 4'd5;
        s = 1'b0;

        #1;


        check_outputs(7'b1011011, 4'b1110, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: x=9 (Hex 9), s=1");
        test_num = 3;
        x = 4'd9;
        s = 1'b1;

        #1;


        check_outputs(7'b1111011, 4'b1110, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: x=10, s=0 (Adjusted to range 0-3 -> 0)");
        test_num = 4;
        x = 4'd10;
        s = 1'b0;

        #1;


        check_outputs(7'b1111110, 4'b1110, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: x=13, s=0 (Adjusted to range 0-3 -> 3)");
        test_num = 5;
        x = 4'd13;
        s = 1'b0;

        #1;


        check_outputs(7'b1111001, 4'b1110, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: x=10, s=1 (Fixed digit '1')");
        test_num = 6;
        x = 4'd10;
        s = 1'b1;

        #1;


        check_outputs(7'b0110000, 4'b1110, 1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: x=15, s=1 (Fixed digit '1')");
        test_num = 7;
        x = 4'd15;
        s = 1'b1;

        #1;


        check_outputs(7'b0110000, 4'b1110, 1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: x=3 (Hex 3), s=0");
        test_num = 8;
        x = 4'd3;
        s = 1'b0;

        #1;


        check_outputs(7'b1111001, 4'b1110, 1'b1);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: x=11, s=0 (Adjusted to range 0-3 -> 1)");
        test_num = 9;
        x = 4'd11;
        s = 1'b0;

        #1;


        check_outputs(7'b0110000, 4'b1110, 1'b1);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: x=12, s=0 (Adjusted to range 0-3 -> 2)");
        test_num = 10;
        x = 4'd12;
        s = 1'b0;

        #1;


        check_outputs(7'b1101101, 4'b1110, 1'b1);
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
        input [6:0] expected_a_to_g;
        input [3:0] expected_an;
        input expected_dp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_to_g === (expected_a_to_g ^ a_to_g ^ expected_a_to_g) &&
                expected_an === (expected_an ^ an ^ expected_an) &&
                expected_dp === (expected_dp ^ dp ^ expected_dp)) begin
                $display("PASS");
                $display("  Outputs: a_to_g=%h, an=%h, dp=%b",
                         a_to_g, an, dp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_to_g=%h, an=%h, dp=%b",
                         expected_a_to_g, expected_an, expected_dp);
                $display("  Got:      a_to_g=%h, an=%h, dp=%b",
                         a_to_g, an, dp);
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
