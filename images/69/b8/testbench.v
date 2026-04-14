`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg mode;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .mode(mode),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (4 + 3)", test_num);
            a = 4'd4;
            b = 4'd3;
            mode = 1'b1;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (10 + 10)", test_num);
            a = 4'd10;
            b = 4'd10;
            mode = 1'b1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            a = 4'd10;
            b = 4'd4;
            mode = 1'b0;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Negative (4 - 10)", test_num);
            a = 4'd4;
            b = 4'd10;
            mode = 1'b0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Case Addition (0 + 0)", test_num);
            a = 4'd0;
            b = 4'd0;
            mode = 1'b1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Case Subtraction (0 - 0)", test_num);
            a = 4'd0;
            b = 4'd0;
            mode = 1'b0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Boundary Addition (15 + 1)", test_num);
            a = 4'hF;
            b = 4'h1;
            mode = 1'b1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction to -1 (0 - 1)", test_num);
            a = 4'h0;
            b = 4'h1;
            mode = 1'b0;
            #1;

            check_outputs(4'hF);
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
        input [3:0] expected_out;
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
