`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg [1:0] ctrl;
    reg rst;
    wire [7:0] result;
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
        .ctrl(ctrl),
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
            @(posedge clk);
            rst = 1;
            a = 0;
            b = 0;
            ctrl = 0;
            @(posedge clk);
            rst = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd120;
            b = 8'd35;
            ctrl = 2'b00;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Addition (120 + 35)", test_num);
            #1;

            check_outputs(8'd155, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd200;
            b = 8'd100;
            ctrl = 2'b00;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Addition Overflow (200 + 100 = 300 -> 44)", test_num);
            #1;

            check_outputs(8'd44, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd100;
            b = 8'd40;
            ctrl = 2'b01;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Subtraction (100 - 40)", test_num);
            #1;

            check_outputs(8'd60, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd10;
            b = 8'd20;
            ctrl = 2'b01;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Subtraction Underflow (10 - 20 = -10 -> 246)", test_num);
            #1;

            check_outputs(8'd246, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd12;
            b = 8'd10;
            ctrl = 2'b10;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Multiplication (12 * 10)", test_num);
            #1;

            check_outputs(8'd120, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd64;
            b = 8'd10;
            ctrl = 2'b10;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Multiplication Truncation (64 * 10 = 640 -> 128)", test_num);
            #1;

            check_outputs(8'd128, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd200;
            b = 8'd5;
            ctrl = 2'b11;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Successful Division (200 / 5)", test_num);
            #1;

            check_outputs(8'd40, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd100;
            b = 8'd0;
            ctrl = 2'b11;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Division by Zero", test_num);

            #1;


            check_outputs(result, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;

            a = 8'hFF; b = 8'hFF; ctrl = 2'b00;
            @(posedge clk);

            rst = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Reset State Verification", test_num);
            #1;

            check_outputs(8'd0, 1'b0);
            rst = 0;
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
        input [7:0] expected_result;
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
        $dumpvars(0,a, b, clk, ctrl, rst, result, valid);
    end

endmodule
