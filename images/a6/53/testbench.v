`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Positive Subtraction (100 - 40)", test_num);
            a = 16'd100;
            b = 16'd40;
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive - Positive resulting in Negative (50 - 100)", test_num);
            a = 16'd50;
            b = 16'd100;
            #1;

            check_outputs(16'shFFCE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtracting Zero (500 - 0)", test_num);
            a = 16'd500;
            b = 16'd0;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtracting from Zero (0 - 500)", test_num);
            a = 16'd0;
            b = 16'd500;
            #1;

            check_outputs(16'shFE0C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative - Positive (-100 - 50)", test_num);
            a = 16'shFF9C;
            b = 16'd50;
            #1;

            check_outputs(16'shFF6A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative - Negative (-100 - (-40))", test_num);
            a = 16'shFF9C;
            b = 16'shFFD8;
            #1;

            check_outputs(16'shFFC4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Positive - Max Negative (32767 - (-32768))", test_num);
            a = 16'h7FFF;
            b = 16'h8000;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Negative - 1 (-32768 - 1)", test_num);
            a = 16'h8000;
            b = 16'h0001;

            #1;


            check_outputs(16'h7FFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtracting Same Negative Numbers (-10 - (-10))", test_num);
            a = 16'shFFF6;
            b = 16'shFFF6;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Negative - Large Positive (-20000 - 20000)", test_num);
            a = 16'shB1E0;
            b = 16'sd20000;

            #1;


            check_outputs(16'h63C0);
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
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
