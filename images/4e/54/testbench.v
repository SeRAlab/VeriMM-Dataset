`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] max_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .max_val(max_val)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: a > b (Small values)", test_num);
            a = 8'd10;
            b = 8'd5;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: b > a (Small values)", test_num);
            a = 8'd20;
            b = 8'd50;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: a == b", test_num);
            a = 8'd100;
            b = 8'd100;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Minimum boundary (0, 0)", test_num);
            a = 8'd0;
            b = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Maximum boundary (255, 255)", test_num);
            a = 8'd255;
            b = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: a is max, b is min", test_num);
            a = 8'd255;
            b = 8'd0;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: a is min, b is max", test_num);
            a = 8'd0;
            b = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Values differing by 1 (a > b)", test_num);
            a = 8'd128;
            b = 8'd127;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Values differing by 1 (b > a)", test_num);
            a = 8'd127;
            b = 8'd128;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Random pattern", test_num);
            a = 8'hA5;
            b = 8'h5A;
            #1;

            check_outputs(8'hA5);
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
        input [7:0] expected_max_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max_val === (expected_max_val ^ max_val ^ expected_max_val)) begin
                $display("PASS");
                $display("  Outputs: max_val=%h",
                         max_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_val=%h",
                         expected_max_val);
                $display("  Got:      max_val=%h",
                         max_val);
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
