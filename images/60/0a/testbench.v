`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg [1:0] op;
    reg rst;
    wire [31:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .op(op),
        .rst(rst),
        .result(result),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            op = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);

            #1;
        end
        endtask
    task wait_for_valid;

        begin

            repeat (20) begin
                if (valid) return;
                @(posedge clk);
            end
            $display("Timeout waiting for valid signal");
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Addition (15 + 27)", test_num);
            a = 32'd15;
            b = 32'd27;
            op = 2'b00;
            wait_for_valid();
            #1;

            check_outputs(32'd42, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Subtraction (100 - 45)", test_num);
            a = 32'd100;
            b = 32'd45;
            op = 2'b01;
            wait_for_valid();
            #1;

            check_outputs(32'd55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Multiplication (12 * 11)", test_num);
            a = 32'd12;
            b = 32'd11;
            op = 2'b10;
            wait_for_valid();
            #1;

            check_outputs(32'd132, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Division (144 / 12)", test_num);
            a = 32'd144;
            b = 32'd12;
            op = 2'b11;
            wait_for_valid();
            #1;

            check_outputs(32'd12, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Addition Overflow", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            op = 2'b00;
            wait_for_valid();
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Subtraction Negative Result (10 - 20)", test_num);
            a = 32'd10;
            b = 32'd20;
            op = 2'b01;
            wait_for_valid();
            #1;

            check_outputs(32'hFFFFFFF6, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case %0d: Multiplication by Zero", test_num);
            a = 32'hABCDE;
            b = 32'd0;
            op = 2'b10;
            wait_for_valid();
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test Case %0d: Division with Remainder (10 / 3)", test_num);
            a = 32'd10;
            b = 32'd3;
            op = 2'b11;
            wait_for_valid();
            #1;

            check_outputs(32'd3, 1'b1);
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
        input [31:0] expected_result;
        input expected_valid;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, clk, op, rst, result, valid);
    end

endmodule
