`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 8'd10;
            b = 8'd3;
            $display("Test Case %0d: Simple subtraction (10 - 3)", test_num);
            #1;

            check_outputs(8'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 8'hFF;
            b = 8'hFF;
            $display("Test Case %0d: Maximum values (255 - 255)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 8'd0;
            b = 8'd0;
            $display("Test Case %0d: Zero values (0 - 0)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 8'd0;
            b = 8'd1;
            $display("Test Case %0d: Underflow/Wrap-around (0 - 1)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 8'd100;
            b = 8'd0;
            $display("Test Case %0d: Subtraction by zero (100 - 0)", test_num);
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 8'd128;
            b = 8'd128;
            $display("Test Case %0d: Midpoint subtraction (128 - 128)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 8'd50;
            b = 8'd100;
            $display("Test Case %0d: Result resulting in wrap-around (50 - 100)", test_num);

            #1;


            check_outputs(8'd206);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 8'hFF;
            b = 8'h01;
            $display("Test Case %0d: Large minus small (255 - 1)", test_num);
            #1;

            check_outputs(8'hFE);
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
        input [7:0] expected_diff;
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
