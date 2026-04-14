`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg sub;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .sub(sub),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a = 0;
        b = 0;
        sub = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Simple Addition (10 + 20)", test_num);
        a = 32'd10;
        b = 32'd20;
        sub = 1'b0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'd30);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Simple Subtraction (50 - 15)", test_num);
        a = 32'd50;
        b = 32'd15;
        sub = 1'b1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'd35);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Addition with Zero (0 + 0xDEADBEEF)", test_num);
        a = 32'h0;
        b = 32'hDEADBEEF;
        sub = 1'b0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Subtraction resulting in Zero (0x123 - 0x123)", test_num);
        a = 32'h123;
        b = 32'h123;
        sub = 1'b1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Addition Overflow (0xFFFFFFFF + 1)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h1;
        sub = 1'b0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Underflow (0 - 1)", test_num);
        a = 32'h0;
        b = 32'h1;
        sub = 1'b1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Large Subtraction (0x80000000 - 0x1)", test_num);
        a = 32'h80000000;
        b = 32'h1;
        sub = 1'b1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h7FFFFFFF);
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
        input [31:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, clk, sub, sum);
    end

endmodule
