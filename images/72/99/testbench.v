`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] num1;
    reg [7:0] num2;
    reg [1:0] op;
    reg rst;
    wire flag;
    wire [15:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .num1(num1),
        .num2(num2),
        .op(op),
        .rst(rst),
        .flag(flag),
        .res(res)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            num1 = 0;
            num2 = 0;
            op = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            num1 = 8'd125;
            num2 = 8'd75;
            op = 2'b00;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Addition (125 + 75)", test_num);
            #1;

            check_outputs(1'b0, 16'd200);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            num1 = 8'd100;
            num2 = 8'd40;
            op = 2'b01;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Subtraction Positive (100 - 40)", test_num);
            #1;

            check_outputs(1'b0, 16'd60);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            num1 = 8'd40;
            num2 = 8'd100;
            op = 2'b01;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Subtraction Negative (40 - 100)", test_num);

            #1;


            check_outputs(1'b1, 16'hFFC4);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            num1 = 8'd25;
            num2 = 8'd10;
            op = 2'b10;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Multiplication (25 * 10)", test_num);
            #1;

            check_outputs(1'b0, 16'd250);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            num1 = 8'd255;
            num2 = 8'd200;
            op = 2'b10;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Multiplication Large (255 * 200)", test_num);
            #1;

            check_outputs(1'b0, 16'd51000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            num1 = 8'd200;
            num2 = 8'd5;
            op = 2'b11;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Division (200 / 5)", test_num);
            #1;

            check_outputs(1'b0, 16'd40);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            num1 = 8'd10;
            num2 = 8'd20;
            op = 2'b11;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Division Zero-Result (10 / 20)", test_num);
            #1;

            check_outputs(1'b0, 16'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            num1 = 8'hFF;
            num2 = 8'hFF;
            op = 2'b00;
            rst = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Reset Initialization Check", test_num);
            #1;

            check_outputs(1'b0, 16'd0);
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
        input expected_flag;
        input [15:0] expected_res;
        begin
            if (expected_flag === (expected_flag ^ flag ^ expected_flag) &&
                expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: flag=%b, res=%h",
                         flag, res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flag=%b, res=%h",
                         expected_flag, expected_res);
                $display("  Got:      flag=%b, res=%h",
                         flag, res);
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
        $dumpvars(0,clk, num1, num2, op, rst, flag, res);
    end

endmodule
