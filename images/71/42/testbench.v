`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg reset;
    reg up_down;
    wire [2:0] count;
    wire overflow;
    wire underflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .reset(reset),
        .up_down(up_down),
        .count(count),
        .overflow(overflow),
        .underflow(underflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            up_down = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset state", test_num);
            reset_dut();
            #1;

            check_outputs(3'b000, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Normal Up Counting", test_num);
            reset_dut();
            up_down = 1;
            load = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd4, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Underflow from 0 to 7", test_num);
            reset_dut();
            up_down = 0;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b111, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Overflow from 7 to 0", test_num);
            reset_dut();
            up_down = 1;
            load = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Load (Hold) Signal", test_num);
            reset_dut();
            up_down = 1;
            load = 0;
            repeat(3) @(posedge clk);
            #1;
            load = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Up then Down switching", test_num);
            reset_dut();
            up_down = 1;
            repeat(5) @(posedge clk);
            #1;
            up_down = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Overflow clearing on next count", test_num);
            reset_dut();
            up_down = 1;
            repeat(8) @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Underflow clearing on next count", test_num);
            reset_dut();
            up_down = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd6, 0, 0);
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
        input [2:0] expected_count;
        input expected_overflow;
        input expected_underflow;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_underflow === (expected_underflow ^ underflow ^ expected_underflow)) begin
                $display("PASS");
                $display("  Outputs: count=%h, overflow=%b, underflow=%b",
                         count, overflow, underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, overflow=%b, underflow=%b",
                         expected_count, expected_overflow, expected_underflow);
                $display("  Got:      count=%h, overflow=%b, underflow=%b",
                         count, overflow, underflow);
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
        $dumpvars(0,clk, load, reset, up_down, count, overflow, underflow);
    end

endmodule
