`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] ctrl;
    reg rst;
    wire flag;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .rst(rst),
        .flag(flag),
        .result(result)
    );
    task apply_reset;

        begin
            rst = 1;
            A = 0;
            B = 0;
            ctrl = 0;
            #10;
            rst = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset", test_num);
            rst = 1; A = 32'd100; B = 32'd50; ctrl = 2'b00;
            #10;

            #1;


            check_outputs(1'b0, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Addition (15 + 25)", test_num);
            apply_reset();
            A = 32'd15; B = 32'd25; ctrl = 2'b00;
            #10;
            #1;

            check_outputs(1'b0, 32'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Addition (-10 + 5)", test_num);
            apply_reset();
            A = -32'd10; B = 32'd5; ctrl = 2'b00;
            #10;
            #1;

            check_outputs(1'b0, -32'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Subtraction (50 - 20)", test_num);
            apply_reset();
            A = 32'd50; B = 32'd20; ctrl = 2'b01;
            #10;
            #1;

            check_outputs(1'b0, 32'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Subtraction (10 - 30)", test_num);
            apply_reset();
            A = 32'd10; B = 32'd30; ctrl = 2'b01;
            #10;
            #1;

            check_outputs(1'b0, -32'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiplication (6 * 7)", test_num);
            apply_reset();
            A = 32'd6; B = 32'd7; ctrl = 2'b10;
            #10;
            #1;

            check_outputs(1'b0, 32'd42);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Multiplication (-4 * 8)", test_num);
            apply_reset();
            A = -32'd4; B = 32'd8; ctrl = 2'b10;
            #10;
            #1;

            check_outputs(1'b0, -32'd32);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Division (100 / 4)", test_num);
            apply_reset();
            A = 32'd100; B = 32'd4; ctrl = 2'b11;
            #10;
            #1;

            check_outputs(1'b0, 32'd25);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Division (-21 / 3)", test_num);
            apply_reset();
            A = -32'd21; B = 32'd3; ctrl = 2'b11;
            #10;
            #1;

            check_outputs(1'b0, -32'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: Division by Zero (50 / 0)", test_num);
            apply_reset();
            A = 32'd50; B = 32'd0; ctrl = 2'b11;
            #10;
            #1;

            check_outputs(1'b1, result);
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
        input expected_flag;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flag === (expected_flag ^ flag ^ expected_flag) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: flag=%b, result=%h",
                         flag, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flag=%b, result=%h",
                         expected_flag, expected_result);
                $display("  Got:      flag=%b, result=%h",
                         flag, result);
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
