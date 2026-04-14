`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    wire [3:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in0 = 4'd5;
            in1 = 4'd2;
            $display("Test %0d: Positive Result (5 - 2)", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in0 = 4'd10;
            in1 = 4'd10;
            $display("Test %0d: Zero Result (10 - 10)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in0 = 4'd2;
            in1 = 4'd5;
            $display("Test %0d: Negative Result Wrap Around (2 - 5 = 13)", test_num);
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in0 = 4'd0;
            in1 = 4'd1;
            $display("Test %0d: Underflow (0 - 1 = 15)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in0 = 4'd15;
            in1 = 4'd0;
            $display("Test %0d: Max minus Zero (15 - 0)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in0 = 4'd15;
            in1 = 4'd15;
            $display("Test %0d: Max minus Max (15 - 15)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in0 = 4'd0;
            in1 = 4'd15;
            $display("Test %0d: Min minus Max (0 - 15 = 1)", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in0 = 4'd8;
            in1 = 4'd7;
            $display("Test %0d: Middle values (8 - 7)", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            in0 = 4'b1100;
            in1 = 4'b0100;
            $display("Test %0d: Binary check (12 - 4)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            in0 = 4'b0111;
            in1 = 4'b1000;
            $display("Test %0d: Boundary Negative (7 - 8 = 15)", test_num);
            #1;

            check_outputs(4'd15);
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
        input [3:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: diff=%h",
                         diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h",
                         expected_diff);
                $display("  Got:      diff=%h",
                         diff);
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
