`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up_down;
    wire [3:0] count_out;
    wire overflow;
    wire underflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .count_out(count_out),
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
            reset = 0;
            up_down = 1;
            @(posedge clk);
            #1 reset = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Increment to 5", test_num);
            reset_dut();
            up_down = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'h5, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Overflow roll-over (15->0)", test_num);
            reset_dut();
            up_down = 1;
            repeat(16) @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Clear overflow flag after rollover", test_num);
            reset_dut();
            up_down = 1;
            repeat(17) @(posedge clk);
            #1 #1;
 check_outputs(4'h1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Underflow roll-over (0->15)", test_num);
            reset_dut();
            up_down = 0;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(4'hf, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Decrement to 13", test_num);
            reset_dut();
            up_down = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(4'hd, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Full cycle down back to 0", test_num);
            reset_dut();
            up_down = 0;
            repeat(16) @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Switching up/down", test_num);
            reset_dut();
            up_down = 1;
            repeat(10) @(posedge clk);
            up_down = 0;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'h6, 0, 0);
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
        input [3:0] expected_count_out;
        input expected_overflow;
        input expected_underflow;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_underflow === (expected_underflow ^ underflow ^ expected_underflow)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, overflow=%b, underflow=%b",
                         count_out, overflow, underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, overflow=%b, underflow=%b",
                         expected_count_out, expected_overflow, expected_underflow);
                $display("  Got:      count_out=%h, overflow=%b, underflow=%b",
                         count_out, overflow, underflow);
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
        $dumpvars(0,clk, reset, up_down, count_out, overflow, underflow);
    end

endmodule
