`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg rst;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking reset state", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase %03d: Shift '1' through 8 cycles", test_num);
            reset_dut();

            @(negedge clk) in = 1;
            for (i = 0; i < 7; i = i + 1) begin
                @(negedge clk) in = 0;
            end

            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Shift '0' through 8 cycles", test_num);
            reset_dut();

            @(negedge clk) in = 0;
            for (i = 0; i < 7; i = i + 1) begin
                @(negedge clk) in = 1;
            end

            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Verify MSB with pattern 10110000", test_num);
            reset_dut();

            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(negedge clk) in = 1;
            @(negedge clk) in = 1;
            @(negedge clk) in = 0;
            @(negedge clk) in = 0;
            @(negedge clk) in = 0;
            @(negedge clk) in = 0;

            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Asynchronous reset mid-shift", test_num);
            reset_dut();

            @(negedge clk) in = 1;
            for (i = 0; i < 3; i = i + 1) @(negedge clk);

            rst = 1;
            #3;
            rst = 0;

            for (i = 0; i < 4; i = i + 1) @(negedge clk) in = 0;

            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,clk, in, rst, out);
    end

endmodule
