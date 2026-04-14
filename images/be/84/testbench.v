`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] i0;
    reg [63:0] i1;
    reg rst;
    wire [31:0] o0;
    wire [31:0] o1;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i0(i0),
        .i1(i1),
        .rst(rst),
        .o0(o0),
        .o1(o1),
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
            i0 = 64'd0;
            i1 = 64'd0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task wait_for_valid;

        integer timeout;
        begin
            timeout = 0;
            while (!valid && timeout < 50) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
            if (timeout >= 50) $display("Error: Timeout waiting for valid signal");
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Inputs", test_num);
            reset_dut();
            i0 = 64'h00000000_00000000;
            i1 = 64'h00000000_00000000;
            wait_for_valid();
            #1;

            check_outputs(32'h0, 32'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Positive Addition", test_num);
            reset_dut();
            i0 = {32'd10, 32'd20};
            i1 = {32'd5, 32'd3};
            wait_for_valid();
            #1;

            check_outputs(32'd15, 32'd23, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Values", test_num);
            reset_dut();
            i0 = {32'shFFFFFFF6, 32'shFFFFFEC};
            i1 = {32'shFFFFFFFB, 32'shFFFFFFFB};
            wait_for_valid();
            #1;

            check_outputs(32'shFFFFFFF1, 32'shFFFFFFE7, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Signs", test_num);
            reset_dut();
            i0 = {32'd100, 32'shFFFFFFCE};
            i1 = {32'shFFFFFFE2, 32'd20};
            wait_for_valid();
            #1;

            check_outputs(32'd70, 32'shFFFFFFE2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Value Wrap", test_num);
            reset_dut();
            i0 = {32'h7FFFFFFF, 32'h00000000};
            i1 = {32'h00000001, 32'h00000000};
            wait_for_valid();
            #1;

            check_outputs(32'h80000000, 32'h00000000, 1'b1);
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
        input [31:0] expected_o0;
        input [31:0] expected_o1;
        input expected_valid;
        begin
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: o0=%h, o1=%h, valid=%b",
                         o0, o1, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%h, o1=%h, valid=%b",
                         expected_o0, expected_o1, expected_valid);
                $display("  Got:      o0=%h, o1=%h, valid=%b",
                         o0, o1, valid);
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
        $dumpvars(0,clk, i0, i1, rst, o0, o1, valid);
    end

endmodule
