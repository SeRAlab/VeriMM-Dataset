`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire equal_flag;
    wire [7:0] max;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .equal_flag(equal_flag),
        .max(max)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'd100;
            b = 8'd50;
            $display("Testcase %0d: a > b (a=100, b=50)", test_num);
            #1;

            check_outputs(1'b0, 8'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'd30;
            b = 8'd80;
            $display("Testcase %0d: b > a (a=30, b=80)", test_num);
            #1;

            check_outputs(1'b0, 8'd80);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'd128;
            b = 8'd128;
            $display("Testcase %0d: a == b (a=128, b=128)", test_num);
            #1;

            check_outputs(1'b1, 8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'd255;
            b = 8'd0;
            $display("Testcase %0d: Boundary values (a=255, b=0)", test_num);
            #1;

            check_outputs(1'b0, 8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'd0;
            b = 8'd255;
            $display("Testcase %0d: Boundary values (a=0, b=255)", test_num);
            #1;

            check_outputs(1'b0, 8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'd0;
            b = 8'd0;
            $display("Testcase %0d: Zero equality (a=0, b=0)", test_num);
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'd255;
            b = 8'd255;
            $display("Testcase %0d: Max value equality (a=255, b=255)", test_num);
            #1;

            check_outputs(1'b1, 8'd255);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'd127;
            b = 8'd128;
            $display("Testcase %0d: One bit difference (a=127, b=128)", test_num);
            #1;

            check_outputs(1'b0, 8'd128);
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
        input expected_equal_flag;
        input [7:0] expected_max;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal_flag === (expected_equal_flag ^ equal_flag ^ expected_equal_flag) &&
                expected_max === (expected_max ^ max ^ expected_max)) begin
                $display("PASS");
                $display("  Outputs: equal_flag=%b, max=%h",
                         equal_flag, max);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal_flag=%b, max=%h",
                         expected_equal_flag, expected_max);
                $display("  Got:      equal_flag=%b, max=%h",
                         equal_flag, max);
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
