`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Divisor;
    reg clk;
    reg rst;
    wire clkOut;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Divisor(Divisor),
        .clk(clk),
        .rst(rst),
        .clkOut(clkOut),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Divisor = 32'd0;
            @(posedge clk);
            #1;
            rst = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Divisor = 2, 2 cycles", test_num);
            reset_dut();
            Divisor = 32'd2;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Divisor = 4, 4 cycles", test_num);
            reset_dut();
            Divisor = 32'd4;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Divisor = 4, 8 cycles (Full Period)", test_num);
            reset_dut();
            Divisor = 32'd4;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 32'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Divisor = 10, 5 cycles (Mid-way)", test_num);
            reset_dut();
            Divisor = 32'd10;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 32'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Divisor = 3, 3 cycles", test_num);
            reset_dut();
            Divisor = 32'd3;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Divisor = 1, 2 cycles", test_num);
            reset_dut();
            Divisor = 32'd1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Divisor = 1000, 1000 cycles", test_num);
            reset_dut();
            Divisor = 32'd1000;
            repeat(1000) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd0);
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
        input expected_clkOut;
        input [31:0] expected_count;
        begin
            if (expected_clkOut === (expected_clkOut ^ clkOut ^ expected_clkOut) &&
                expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: clkOut=%b, count=%h",
                         clkOut, count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clkOut=%b, count=%h",
                         expected_clkOut, expected_count);
                $display("  Got:      clkOut=%b, count=%h",
                         clkOut, count);
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
        $dumpvars(0,Divisor, clk, rst, clkOut, count);
    end

endmodule
