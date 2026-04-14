`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg add;
    reg [7:0] b;
    reg sub;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .add(add),
        .b(b),
        .sub(sub),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Addition (10 + 5)", test_num);
            a = 8'd10;
            b = 8'd5;
            add = 1'b1;
            sub = 1'b0;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic Subtraction (20 - 5)", test_num);
            a = 8'd20;
            b = 8'd5;
            add = 1'b0;
            sub = 1'b1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: No Operation Selected (add=0, sub=0)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            add = 1'b0;
            sub = 1'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Addition with Overflow (255 + 1)", test_num);
            a = 8'd255;
            b = 8'd1;
            add = 1'b1;
            sub = 1'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Subtraction with Underflow (0 - 1)", test_num);
            a = 8'd0;
            b = 8'd1;
            add = 1'b0;
            sub = 1'b1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Subtraction resulting in Zero (128 - 128)", test_num);
            a = 8'd128;
            b = 8'd128;
            add = 1'b0;
            sub = 1'b1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Addition of zero values", test_num);
            a = 8'd0;
            b = 8'd0;
            add = 1'b1;
            sub = 1'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Maximum values addition (255 + 255)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            add = 1'b1;
            sub = 1'b0;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Subtraction from maximum value (255 - 255)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            add = 1'b0;
            sub = 1'b1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: No Operation Selected with different inputs", test_num);
            a = 8'd42;
            b = 8'd24;
            add = 1'b0;
            sub = 1'b0;
            #1;

            check_outputs(8'd0);
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
