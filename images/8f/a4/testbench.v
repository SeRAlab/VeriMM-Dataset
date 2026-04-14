`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] vector1;
    reg [7:0] vector2;
    wire [7:0] swapped_vector1;
    wire [7:0] swapped_vector2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vector1(vector1),
        .vector2(vector2),
        .swapped_vector1(swapped_vector1),
        .swapped_vector2(swapped_vector2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Swap (AA, 55)", test_num);
            vector1 = 8'hAA;
            vector2 = 8'h55;
            #1;

            check_outputs(8'h55, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Values (00, FF)", test_num);
            vector1 = 8'h00;
            vector2 = 8'hFF;
            #1;

            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identical Values (88, 88)", test_num);
            vector1 = 8'h88;
            vector2 = 8'h88;
            #1;

            check_outputs(8'h88, 8'h88);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Pattern 1 (DE, AD)", test_num);
            vector1 = 8'hDE;
            vector2 = 8'hAD;
            #1;

            check_outputs(8'hAD, 8'hDE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Pattern 2 (12, 34)", test_num);
            vector1 = 8'h12;
            vector2 = 8'h34;
            #1;

            check_outputs(8'h34, 8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Bit Shift (01, 80)", test_num);
            vector1 = 8'h01;
            vector2 = 8'h80;
            #1;

            check_outputs(8'h80, 8'h01);
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
        input [7:0] expected_swapped_vector1;
        input [7:0] expected_swapped_vector2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_swapped_vector1 === (expected_swapped_vector1 ^ swapped_vector1 ^ expected_swapped_vector1) &&
                expected_swapped_vector2 === (expected_swapped_vector2 ^ swapped_vector2 ^ expected_swapped_vector2)) begin
                $display("PASS");
                $display("  Outputs: swapped_vector1=%h, swapped_vector2=%h",
                         swapped_vector1, swapped_vector2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: swapped_vector1=%h, swapped_vector2=%h",
                         expected_swapped_vector1, expected_swapped_vector2);
                $display("  Got:      swapped_vector1=%h, swapped_vector2=%h",
                         swapped_vector1, swapped_vector2);
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
