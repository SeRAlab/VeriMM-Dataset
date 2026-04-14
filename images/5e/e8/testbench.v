`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] d;
    wire [9:0] flip_lower;
    wire [9:0] zero_upper;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .flip_lower(flip_lower),
        .zero_upper(zero_upper)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            d = 10'b00000_00000;


            #1;



            check_outputs(10'b00000_11111, 10'b00000_00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            d = 10'b11111_11111;


            #1;



            check_outputs(10'b11111_00000, 10'b00000_11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (Pattern A)", test_num);
            d = 10'b10101_10101;


            #1;



            check_outputs(10'b10101_01010, 10'b00000_10101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (Pattern B)", test_num);
            d = 10'b01010_01010;


            #1;



            check_outputs(10'b01010_10101, 10'b00000_01010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Specification Example (Standard Interpretation)", test_num);
            d = 10'b11001_10011;


            #1;



            check_outputs(10'b11001_01100, 10'b00000_10011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Lower Half Boundary", test_num);
            d = 10'b11111_00001;


            #1;



            check_outputs(10'b11111_11110, 10'b00000_00001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Upper Half Boundary", test_num);
            d = 10'b10000_11111;


            #1;



            check_outputs(10'b10000_00000, 10'b00000_11111);
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
        input [9:0] expected_flip_lower;
        input [9:0] expected_zero_upper;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flip_lower === (expected_flip_lower ^ flip_lower ^ expected_flip_lower) &&
                expected_zero_upper === (expected_zero_upper ^ zero_upper ^ expected_zero_upper)) begin
                $display("PASS");
                $display("  Outputs: flip_lower=%h, zero_upper=%h",
                         flip_lower, zero_upper);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flip_lower=%h, zero_upper=%h",
                         expected_flip_lower, expected_zero_upper);
                $display("  Got:      flip_lower=%h, zero_upper=%h",
                         flip_lower, zero_upper);
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
