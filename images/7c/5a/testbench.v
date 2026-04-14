`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] mode;
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mode(mode),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Mode 11 (Unique Pattern)", test_num);
            mode = 2'b11;
            #10;


            #1;



            check_outputs(7'h01, 7'h02, 7'h03, 7'h04);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Mode 00 (Distinct Pattern)", test_num);
            mode = 2'b00;
            #10;

            #1;


            check_outputs(7'h05, 7'h06, 7'h07, 7'h08);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Mode 01 (Default Pattern)", test_num);
            mode = 2'b01;
            #10;

            #1;


            check_outputs(7'h09, 7'h0A, 7'h0B, 7'h0C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Mode 10 (Default Pattern)", test_num);
            mode = 2'b10;
            #10;

            #1;


            check_outputs(7'h09, 7'h0A, 7'h0B, 7'h0C);
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
        input [6:0] expected_HEX0;
        input [6:0] expected_HEX1;
        input [6:0] expected_HEX2;
        input [6:0] expected_HEX3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HEX0 === (expected_HEX0 ^ HEX0 ^ expected_HEX0) &&
                expected_HEX1 === (expected_HEX1 ^ HEX1 ^ expected_HEX1) &&
                expected_HEX2 === (expected_HEX2 ^ HEX2 ^ expected_HEX2) &&
                expected_HEX3 === (expected_HEX3 ^ HEX3 ^ expected_HEX3)) begin
                $display("PASS");
                $display("  Outputs: HEX0=%h, HEX1=%h, HEX2=%h, HEX3=%h",
                         HEX0, HEX1, HEX2, HEX3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HEX0=%h, HEX1=%h, HEX2=%h, HEX3=%h",
                         expected_HEX0, expected_HEX1, expected_HEX2, expected_HEX3);
                $display("  Got:      HEX0=%h, HEX1=%h, HEX2=%h, HEX3=%h",
                         HEX0, HEX1, HEX2, HEX3);
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
