`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_num;
    reg [4:0] shift_amount;
    wire [31:0] arithmetic_shifted;
    wire [31:0] left_shifted;
    wire [31:0] right_shifted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_num(input_num),
        .shift_amount(shift_amount),
        .arithmetic_shifted(arithmetic_shifted),
        .left_shifted(left_shifted),
        .right_shifted(right_shifted)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Shift", test_num);
            input_num = 32'hA5A5A5A5;
            shift_amount = 5'd0;
            #1;

            check_outputs(
                32'hA5A5A5A5,
                32'hA5A5A5A5,
                32'hA5A5A5A5
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Left Shift", test_num);
            input_num = 32'h00000001;
            shift_amount = 5'd4;
            #1;

            check_outputs(
                32'h00000000,
                32'h00000010,
                32'h00000000
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Shift (Positive)", test_num);
            input_num = 32'h40000000;
            shift_amount = 5'd2;
            #1;

            check_outputs(
                32'h10000000,
                32'h00000000,
                32'h10000000
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Shift (Negative)", test_num);
            input_num = 32'h80000000;
            shift_amount = 5'd4;
            #1;

            check_outputs(
                32'hF8000000,
                32'h00000000,
                32'h08000000
            );
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Shift (31)", test_num);
            input_num = 32'hFFFFFFFF;
            shift_amount = 5'd31;
            #1;

            check_outputs(
                32'hFFFFFFFF,
                32'h80000000,
                32'h00000001
            );
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range Shift (16)", test_num);
            input_num = 32'h12345678;
            shift_amount = 5'd16;
            #1;

            check_outputs(
                32'h00001234,
                32'h56780000,
                32'h00001234
            );
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arithmetic preservation", test_num);
            input_num = 32'hF0000000;
            shift_amount = 5'd8;
            #1;

            check_outputs(
                32'hFFF00000,
                32'h00000000,
                32'h00F00000
            );
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
        input [31:0] expected_arithmetic_shifted;
        input [31:0] expected_left_shifted;
        input [31:0] expected_right_shifted;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_arithmetic_shifted === (expected_arithmetic_shifted ^ arithmetic_shifted ^ expected_arithmetic_shifted) &&
                expected_left_shifted === (expected_left_shifted ^ left_shifted ^ expected_left_shifted) &&
                expected_right_shifted === (expected_right_shifted ^ right_shifted ^ expected_right_shifted)) begin
                $display("PASS");
                $display("  Outputs: arithmetic_shifted=%h, left_shifted=%h, right_shifted=%h",
                         arithmetic_shifted, left_shifted, right_shifted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: arithmetic_shifted=%h, left_shifted=%h, right_shifted=%h",
                         expected_arithmetic_shifted, expected_left_shifted, expected_right_shifted);
                $display("  Got:      arithmetic_shifted=%h, left_shifted=%h, right_shifted=%h",
                         arithmetic_shifted, left_shifted, right_shifted);
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
