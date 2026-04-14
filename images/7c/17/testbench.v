`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] op1;
    reg [15:0] op2;
    reg [2:0] operator;
    reg rst;
    wire [15:0] out;
    wire [15:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .op1(op1),
        .op2(op2),
        .operator(operator),
        .rst(rst),
        .out(out),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 0;
            op1 = 0;
            op2 = 0;
            operator = 0;
            @(negedge clk);
            rst = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Addition", test_num);
            operator = 3'd0;
            op1 = 16'd100;
            op2 = 16'd250;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd350, 16'd350);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Subtraction", test_num);
            operator = 3'd1;
            op1 = 16'd500;
            op2 = 16'd150;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd350, 16'd350);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Multiplication", test_num);
            operator = 3'd2;
            op1 = 16'd25;
            op2 = 16'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd250, 16'd250);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: bitwise NAND", test_num);
            operator = 3'd3;
            op1 = 16'h00FF;
            op2 = 16'h0F0F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFF0, 16'hFFF0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Division", test_num);
            operator = 3'd4;
            op1 = 16'd1000;
            op2 = 16'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd333, 16'd333);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Modulus", test_num);
            operator = 3'd5;
            op1 = 16'd1000;
            op2 = 16'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1, 16'd1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Comparison (Greater Than)", test_num);
            operator = 3'd6;
            op1 = 16'd50;
            op2 = 16'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1, 16'd1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Comparison (False Result)", test_num);
            operator = 3'd6;
            op1 = 16'd20;
            op2 = 16'd50;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd0, 16'd0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %0d: Reset during operation", test_num);
            operator = 3'd0;
            op1 = 16'hAAAA;
            op2 = 16'h5555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);

            @(negedge clk);
            rst = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000);
            rst = 1;
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Testcase %0d: Multiplication Overflow", test_num);
            operator = 3'd2;
            op1 = 16'h1000;
            op2 = 16'h0020;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_out;
        input [15:0] expected_status;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: out=%h, status=%h",
                         out, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, status=%h",
                         expected_out, expected_status);
                $display("  Got:      out=%h, status=%h",
                         out, status);
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
        $dumpvars(0,clk, op1, op2, operator, rst, out, status);
    end

endmodule
