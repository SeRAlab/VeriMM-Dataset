`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg enable;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .enable(enable),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'd5;
        b = 4'd3;
        enable = 1'b0;
        $display("Test %0d: Enable low (a=5, b=3, en=0)", test_num);
        #1;

        check_outputs(8'sh00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'sb0011;
        b = 4'sb0100;
        enable = 1'b1;
        $display("Test %0d: Positive * Positive (3 * 4)", test_num);
        #1;

        check_outputs(8'sd12);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'sb0101;
        b = 4'sb1110;
        enable = 1'b1;
        $display("Test %0d: Positive * Negative (5 * -2)", test_num);
        #1;

        check_outputs(-8'sd10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'sb1001;
        b = 4'sb0011;
        enable = 1'b1;
        $display("Test %0d: Negative * Positive (-7 * 3)", test_num);
        #1;

        check_outputs(-8'sd21);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'sb1100;
        b = 4'sb1101;
        enable = 1'b1;
        $display("Test %0d: Negative * Negative (-4 * -3)", test_num);
        #1;

        check_outputs(8'sd12);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'sb0000;
        b = 4'sb1000;
        enable = 1'b1;
        $display("Test %0d: Multiply by Zero (0 * -8)", test_num);
        #1;

        check_outputs(8'sd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'sb0111;
        b = 4'sb0111;
        enable = 1'b1;
        $display("Test %0d: Max Positive * Max Positive (7 * 7)", test_num);
        #1;

        check_outputs(8'sd49);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'sb1000;
        b = 4'sb0111;
        enable = 1'b1;
        $display("Test %0d: Min Negative * Max Positive (-8 * 7)", test_num);
        #1;

        check_outputs(-8'sd56);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'sb1000;
        b = 4'sb1000;
        enable = 1'b1;
        $display("Test %0d: Min Negative * Min Negative (-8 * -8)", test_num);
        #1;

        check_outputs(8'sd64);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'sb0010;
        b = 4'sb0011;
        enable = 1'b1;
        #1;
        enable = 1'b0;
        $display("Test %0d: Disable enable after setting values (result should be 0)", test_num);
        #1;

        check_outputs(8'sd0);
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
