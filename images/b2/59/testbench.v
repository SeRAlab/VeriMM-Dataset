`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    wire [15:0] add_result;
    wire [15:0] div_result;
    wire [15:0] mul_result;
    wire [15:0] sub_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .add_result(add_result),
        .div_result(div_result),
        .mul_result(mul_result),
        .sub_result(sub_result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 8'h0;
            B = 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: A=10, B=5", test_num);
            A = 8'd10;
            B = 8'd5;


            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'd15, 16'd2, 16'd50, 16'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: A=255, B=255", test_num);
            A = 8'hFF;
            B = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'd510, 16'd1, 16'd65025, 16'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: A=10, B=20", test_num);
            A = 8'd10;
            B = 8'd20;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'd30, 16'd0, 16'd200, 16'hFFF6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: A=100, B=3", test_num);
            A = 8'd100;
            B = 8'd3;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'd103, 16'd33, 16'd300, 16'd97);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: A=255, B=2", test_num);
            A = 8'd255;
            B = 8'd2;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'd257, 16'd127, 16'd510, 16'd253);
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
        input [15:0] expected_add_result;
        input [15:0] expected_div_result;
        input [15:0] expected_mul_result;
        input [15:0] expected_sub_result;
        begin
            if (expected_add_result === (expected_add_result ^ add_result ^ expected_add_result) &&
                expected_div_result === (expected_div_result ^ div_result ^ expected_div_result) &&
                expected_mul_result === (expected_mul_result ^ mul_result ^ expected_mul_result) &&
                expected_sub_result === (expected_sub_result ^ sub_result ^ expected_sub_result)) begin
                $display("PASS");
                $display("  Outputs: add_result=%h, div_result=%h, mul_result=%h, sub_result=%h",
                         add_result, div_result, mul_result, sub_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_result=%h, div_result=%h, mul_result=%h, sub_result=%h",
                         expected_add_result, expected_div_result, expected_mul_result, expected_sub_result);
                $display("  Got:      add_result=%h, div_result=%h, mul_result=%h, sub_result=%h",
                         add_result, div_result, mul_result, sub_result);
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
        $dumpvars(0,A, B, clk, add_result, div_result, mul_result, sub_result);
    end

endmodule
