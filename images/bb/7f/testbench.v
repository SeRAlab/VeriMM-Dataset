`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [14:0] din;
    wire out00;
    wire out01;
    wire out02;
    wire out03;
    wire out04;
    wire out05;
    wire out06;
    wire out07;
    wire out08;
    wire out09;
    wire out10;
    wire out11;
    wire out12;
    wire out13;
    wire out14;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .out00(out00),
        .out01(out01),
        .out02(out02),
        .out03(out03),
        .out04(out04),
        .out05(out05),
        .out06(out06),
        .out07(out07),
        .out08(out08),
        .out09(out09),
        .out10(out10),
        .out11(out11),
        .out12(out12),
        .out13(out13),
        .out14(out14)
    );
    task testcase001;

    begin
        $display("Testcase 001: All zeros");
        din = 15'h0000;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: All ones");
        din = 15'h7FFF;
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Alternating bits (101010101010101)");
        din = 15'h5555;
        #1;

        check_outputs(1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Alternating bits (010101010101010)");
        din = 15'h2AAA;
        #1;

        check_outputs(0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Walking one - LSB");
        din = 15'h0001;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Walking one - MSB");
        din = 15'h4000;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Walking one - Mid bit (bit 7)");
        din = 15'h0080;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Pattern 0x1234");


        din = 15'h1234;

        #1;


        check_outputs(0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Pattern 0x7ABC");

        din = 15'h7ABC;



        #1;




        check_outputs(0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Power of 2 (bit 10)");
        din = 15'd1024;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0);
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
        input expected_out00;
        input expected_out01;
        input expected_out02;
        input expected_out03;
        input expected_out04;
        input expected_out05;
        input expected_out06;
        input expected_out07;
        input expected_out08;
        input expected_out09;
        input expected_out10;
        input expected_out11;
        input expected_out12;
        input expected_out13;
        input expected_out14;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out00 === (expected_out00 ^ out00 ^ expected_out00) &&
                expected_out01 === (expected_out01 ^ out01 ^ expected_out01) &&
                expected_out02 === (expected_out02 ^ out02 ^ expected_out02) &&
                expected_out03 === (expected_out03 ^ out03 ^ expected_out03) &&
                expected_out04 === (expected_out04 ^ out04 ^ expected_out04) &&
                expected_out05 === (expected_out05 ^ out05 ^ expected_out05) &&
                expected_out06 === (expected_out06 ^ out06 ^ expected_out06) &&
                expected_out07 === (expected_out07 ^ out07 ^ expected_out07) &&
                expected_out08 === (expected_out08 ^ out08 ^ expected_out08) &&
                expected_out09 === (expected_out09 ^ out09 ^ expected_out09) &&
                expected_out10 === (expected_out10 ^ out10 ^ expected_out10) &&
                expected_out11 === (expected_out11 ^ out11 ^ expected_out11) &&
                expected_out12 === (expected_out12 ^ out12 ^ expected_out12) &&
                expected_out13 === (expected_out13 ^ out13 ^ expected_out13) &&
                expected_out14 === (expected_out14 ^ out14 ^ expected_out14)) begin
                $display("PASS");
                $display("  Outputs: out00=%b, out01=%b, out02=%b, out03=%b, out04=%b, out05=%b, out06=%b, out07=%b, out08=%b, out09=%b, out10=%b, out11=%b, out12=%b, out13=%b, out14=%b",
                         out00, out01, out02, out03, out04, out05, out06, out07, out08, out09, out10, out11, out12, out13, out14);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out00=%b, out01=%b, out02=%b, out03=%b, out04=%b, out05=%b, out06=%b, out07=%b, out08=%b, out09=%b, out10=%b, out11=%b, out12=%b, out13=%b, out14=%b",
                         expected_out00, expected_out01, expected_out02, expected_out03, expected_out04, expected_out05, expected_out06, expected_out07, expected_out08, expected_out09, expected_out10, expected_out11, expected_out12, expected_out13, expected_out14);
                $display("  Got:      out00=%b, out01=%b, out02=%b, out03=%b, out04=%b, out05=%b, out06=%b, out07=%b, out08=%b, out09=%b, out10=%b, out11=%b, out12=%b, out13=%b, out14=%b",
                         out00, out01, out02, out03, out04, out05, out06, out07, out08, out09, out10, out11, out12, out13, out14);
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
