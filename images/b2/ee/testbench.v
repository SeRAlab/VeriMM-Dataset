`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire flag_negative;
    wire flag_positive;
    wire flag_zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .flag_negative(flag_negative),
        .flag_positive(flag_positive),
        .flag_zero(flag_zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking Zero (in = 0x0000)", test_num);
        in = 16'h0000;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking Small Positive (in = 0x0001)", test_num);
        in = 16'h0001;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking Max Positive (in = 0x7FFF)", test_num);
        in = 16'h7FFF;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking MSB-only Negative (in = 0x8000)", test_num);
        in = 16'h8000;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking All Ones (in = 0xFFFF)", test_num);
        in = 16'hFFFF;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking Random Positive (in = 0x1234)", test_num);
        in = 16'h1234;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking Random Negative (in = 0xABCD)", test_num);
        in = 16'hABCD;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_flag_negative;
        input expected_flag_positive;
        input expected_flag_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flag_negative === (expected_flag_negative ^ flag_negative ^ expected_flag_negative) &&
                expected_flag_positive === (expected_flag_positive ^ flag_positive ^ expected_flag_positive) &&
                expected_flag_zero === (expected_flag_zero ^ flag_zero ^ expected_flag_zero)) begin
                $display("PASS");
                $display("  Outputs: flag_negative=%b, flag_positive=%b, flag_zero=%b",
                         flag_negative, flag_positive, flag_zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flag_negative=%b, flag_positive=%b, flag_zero=%b",
                         expected_flag_negative, expected_flag_positive, expected_flag_zero);
                $display("  Got:      flag_negative=%b, flag_positive=%b, flag_zero=%b",
                         flag_negative, flag_positive, flag_zero);
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
