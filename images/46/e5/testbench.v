`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] io_x;
    reg reset;
    wire [15:0] io_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_x(io_x),
        .reset(reset),
        .io_y(io_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            io_x = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Sequence Sum (10, 20, 30)", test_num);
            reset_dut();
            @(posedge clk) io_x = 16'd10;
            @(posedge clk) io_x = 16'd20;
            @(posedge clk) io_x = 16'd30;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd60);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pipeline Clear with Zeros", test_num);
            reset_dut();
            @(posedge clk) io_x = 16'd100;
            @(posedge clk) io_x = 16'd0;
            @(posedge clk) io_x = 16'd0;
            @(posedge clk) io_x = 16'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Handling", test_num);
            reset_dut();
            @(posedge clk) io_x = 16'd30000;
            @(posedge clk) io_x = 16'd30000;
            @(posedge clk) io_x = 16'd30000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd24464);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-operation Reset", test_num);
            reset_dut();
            @(posedge clk) io_x = 16'hFFFF;
            @(posedge clk) io_x = 16'hFFFF;
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hexadecimal Pattern", test_num);
            reset_dut();
            @(posedge clk) io_x = 16'h1234;
            @(posedge clk) io_x = 16'h1234;
            @(posedge clk) io_x = 16'h1234;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h369C);
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
        input [15:0] expected_io_y;
        begin
            if (expected_io_y === (expected_io_y ^ io_y ^ expected_io_y)) begin
                $display("PASS");
                $display("  Outputs: io_y=%h",
                         io_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_y=%h",
                         expected_io_y);
                $display("  Got:      io_y=%h",
                         io_y);
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
        $dumpvars(0,clk, io_x, reset, io_y);
    end

endmodule
