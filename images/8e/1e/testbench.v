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
            test_num = test_num + 1;
            $display("Test Case %0d: a > b (Typical values)", test_num);
            a = 8'd50;
            b = 8'd20;
            #1;

            check_outputs(1'b0, 8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a < b (Typical values)", test_num);
            a = 8'd10;
            b = 8'd100;
            #1;

            check_outputs(1'b0, 8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a == b (Non-zero)", test_num);
            a = 8'd128;
            b = 8'd128;
            #1;

            check_outputs(1'b1, 8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - All zeros", test_num);
            a = 8'h00;
            b = 8'h00;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - All ones", test_num);
            a = 8'hFF;
            b = 8'hFF;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a is max, b is zero", test_num);
            a = 8'hFF;
            b = 8'h00;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: b is max, a is zero", test_num);
            a = 8'h00;
            b = 8'hFF;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Comparison near threshold", test_num);
            a = 8'd127;
            b = 8'd128;
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
