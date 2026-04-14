`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [3:0] op;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 16'h000A; b = 16'h0014; op = 4'd0;
            $display("Test %0d: Addition (10 + 20)", test_num);
            #1;

            check_outputs(16'h001E);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 16'h0064; b = 16'h0032; op = 4'd1;
            $display("Test %0d: Subtraction (100 - 50)", test_num);
            #1;

            check_outputs(16'h0032);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 16'h000C; b = 16'h000C; op = 4'd2;
            $display("Test %0d: Multiplication (12 * 12)", test_num);
            #1;

            check_outputs(16'h0090);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 16'h00FF; b = 16'h000F; op = 4'd3;
            $display("Test %0d: Division (255 / 15)", test_num);
            #1;

            check_outputs(16'h0011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 16'hFFFF; b = 16'h0001; op = 4'd0;
            $display("Test %0d: Addition Overflow (65535 + 1)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 16'h0005; b = 16'h000A; op = 4'd1;
            $display("Test %0d: Subtraction Underflow (5 - 10)", test_num);
            #1;

            check_outputs(16'hFFF6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 16'h0100; b = 16'h0100; op = 4'd2;
            $display("Test %0d: Multiplication Truncation (256 * 256)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 16'h1234; b = 16'h5678; op = 4'd4;
            $display("Test %0d: Undefined Operation (op=4)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 16'hAAAA; b = 16'h5555; op = 4'hF;
            $display("Test %0d: Undefined Operation (op=15)", test_num);
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_result;
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
