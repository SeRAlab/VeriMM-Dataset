`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] num1;
    reg [15:0] num2;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num1(num1),
        .num2(num2),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        num1 = 16'sd1500;
        num2 = 16'sd500;
        $display("Test %0d: Positive Comparison (1500 > 500)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        num1 = 16'sd500;
        num2 = 16'sd1500;
        $display("Test %0d: Positive Comparison (500 > 1500)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        num1 = -16'sd10;
        num2 = -16'sd100;
        $display("Test %0d: Negative Comparison (-10 > -100)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        num1 = -16'sd500;
        num2 = -16'sd100;
        $display("Test %0d: Negative Comparison (-500 > -100)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        num1 = 16'sd1;
        num2 = -16'sd1;
        $display("Test %0d: Mixed Sign (1 > -1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        num1 = -16'sd32000;
        num2 = 16'sd100;
        $display("Test %0d: Mixed Sign (-32000 > 100)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        num1 = 16'sd0;
        num2 = 16'sd0;
        $display("Test %0d: Zero Equality (0 > 0)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        num1 = 16'sd32767;
        num2 = 16'sd32767;
        $display("Test %0d: Max Positive Equality (32767 > 32767)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        num1 = 16'sh7FFF;
        num2 = 16'sh8000;
        $display("Test %0d: Boundary (32767 > -32768)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        num1 = 16'sh8000;
        num2 = 16'sh7FFF;
        $display("Test %0d: Boundary (-32768 > 32767)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        num1 = 16'sd0;
        num2 = -16'sd1;
        $display("Test %0d: Zero vs Small Negative (0 > -1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        num1 = 16'sd0;
        num2 = 16'sd1;
        $display("Test %0d: Zero vs Small Positive (0 > 1)", test_num);
        #1;

        check_outputs(1'b0);
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
        testcase011();
        testcase012();
        
        
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
