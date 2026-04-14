`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'd3;
            b = 4'd2;
            $display("Test %0d: Positive * Positive (3 * 2)", test_num);
            #1;

            check_outputs(8'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'sd3;
            b = -4'sd2;
            $display("Test %0d: Positive * Negative (3 * -2)", test_num);
            #1;

            check_outputs(-8'sd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = -4'sd3;
            b = 4'sd2;
            $display("Test %0d: Negative * Positive (-3 * 2)", test_num);
            #1;

            check_outputs(-8'sd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = -4'sd3;
            b = -4'sd2;
            $display("Test %0d: Negative * Negative (-3 * -2)", test_num);
            #1;

            check_outputs(8'sd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'd0;
            b = 4'sd5;
            $display("Test %0d: Zero * Positive (0 * 5)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = -4'sd7;
            b = 4'd0;
            $display("Test %0d: Negative * Zero (-7 * 0)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'sd7;
            b = 4'sd7;
            $display("Test %0d: Max Positive * Max Positive (7 * 7)", test_num);
            #1;

            check_outputs(8'sd49);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = -4'sd8;
            b = -4'sd8;
            $display("Test %0d: Max Negative * Max Negative (-8 * -8)", test_num);
            #1;

            check_outputs(8'sd64);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = -4'sd8;
            b = 4'sd7;
            $display("Test %0d: Max Negative * Max Positive (-8 * 7)", test_num);
            #1;

            check_outputs(-8'sd56);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 4'sd1;
            b = -4'sd1;
            $display("Test %0d: One * Minus One (1 * -1)", test_num);
            #1;

            check_outputs(-8'sd1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            a = -4'sd1;
            b = -4'sd1;
            $display("Test %0d: Minus One * Minus One (-1 * -1)", test_num);
            #1;

            check_outputs(8'sd1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            a = 4'sd2;
            b = -4'sd8;
            $display("Test %0d: Small Positive * Max Negative (2 * -8)", test_num);
            #1;

            check_outputs(-8'sd16);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
