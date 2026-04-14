`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    wire [7:0] diff;
    wire [7:0] prod;
    wire [7:0] quot;
    wire [7:0] sum;
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
        .diff(diff),
        .prod(prod),
        .quot(quot),
        .sum(sum),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            a = 0;
            b = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic arithmetic (a=10, b=2)", test_num);
            @(negedge clk);
            a = 8'd10;
            b = 8'd2;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd8, 8'd20, 8'd5, 8'd12, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Addition Overflow (a=200, b=100)", test_num);
            @(negedge clk);
            a = 8'd200;
            b = 8'd100;
            @(posedge clk);
            #2;




            #1;





            check_outputs(8'd100, 8'd32, 8'd2, 8'd44, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Negative difference (a=10, b=20)", test_num);
            @(negedge clk);
            a = 8'd10;
            b = 8'd20;
            @(posedge clk);
            #2;




            #1;





            check_outputs(8'hF6, 8'd200, 8'd0, 8'd30, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Multiplication Overflow (a=50, b=10)", test_num);
            @(negedge clk);
            a = 8'd50;
            b = 8'd10;
            @(posedge clk);
            #2;




            #1;





            check_outputs(8'd40, 8'd244, 8'd5, 8'd60, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Max values (a=255, b=1)", test_num);
            @(negedge clk);
            a = 8'hFF;
            b = 8'h01;
            @(posedge clk);
            #2;




            #1;





            check_outputs(8'd254, 8'd255, 8'd255, 8'd0, 1'b1);
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
        input [7:0] expected_prod;
        input [7:0] expected_quot;
        input [7:0] expected_sum;
        input expected_valid;
        begin
            if (expected_diff === (expected_diff ^ diff ^ expected_diff) &&
                expected_prod === (expected_prod ^ prod ^ expected_prod) &&
                expected_quot === (expected_quot ^ quot ^ expected_quot) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: diff=%h, prod=%h, quot=%h, sum=%h, valid=%b",
                         diff, prod, quot, sum, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h, prod=%h, quot=%h, sum=%h, valid=%b",
                         expected_diff, expected_prod, expected_quot, expected_sum, expected_valid);
                $display("  Got:      diff=%h, prod=%h, quot=%h, sum=%h, valid=%b",
                         diff, prod, quot, sum, valid);
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
        $dumpvars(0,a, b, clk, diff, prod, quot, sum, valid);
    end

endmodule
