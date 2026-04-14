`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in_word;
    reg [15:0] threshold;
    wire [15:0] out_word;
    wire threshold_exceeded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_word(in_word),
        .threshold(threshold),
        .out_word(out_word),
        .threshold_exceeded(threshold_exceeded)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Sum, Below Threshold", test_num);
            in_word = 32'h0005_000A;
            threshold = 16'h0014;

            #1;


            check_outputs(16'h000F, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Basic Sum, Above Threshold", test_num);
            in_word = 32'h0100_0200;
            threshold = 16'h02FF;

            #1;


            check_outputs(16'h0300, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Sum Equals Threshold", test_num);
            in_word = 32'h0001_0001;
            threshold = 16'h0002;

            #1;


            check_outputs(16'h0002, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: 16-bit Sum Overflow (Truncation)", test_num);


            in_word = 32'hFFFF_0002;
            threshold = 16'h0005;

            #1;


            check_outputs(16'h0001, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Maximum Threshold Boundary", test_num);
            in_word = 32'h7FFF_7FFF;
            threshold = 16'hFFFF;

            #1;


            check_outputs(16'hFFFE, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Zero Threshold Check", test_num);
            in_word = 32'h0000_0001;
            threshold = 16'h0000;

            #1;


            check_outputs(16'h0001, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: All Zeros Input", test_num);
            in_word = 32'h0000_0000;
            threshold = 16'h0000;

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Large Overflow with Exceeded Threshold", test_num);

            in_word = 32'h8000_8001;
            threshold = 16'h0000;

            #1;


            check_outputs(16'h0001, 1'b1);
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
        input [15:0] expected_out_word;
        input expected_threshold_exceeded;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_word === (expected_out_word ^ out_word ^ expected_out_word) &&
                expected_threshold_exceeded === (expected_threshold_exceeded ^ threshold_exceeded ^ expected_threshold_exceeded)) begin
                $display("PASS");
                $display("  Outputs: out_word=%h, threshold_exceeded=%b",
                         out_word, threshold_exceeded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_word=%h, threshold_exceeded=%b",
                         expected_out_word, expected_threshold_exceeded);
                $display("  Got:      out_word=%h, threshold_exceeded=%b",
                         out_word, threshold_exceeded);
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
