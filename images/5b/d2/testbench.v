`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [15:0] final_out;
    wire [7:0] out_hi;
    wire [7:0] out_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .final_out(final_out),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Count=0 Pattern", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs({out_hi, out_lo}, out_hi, out_lo);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Count=1 Pattern", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs({out_lo, out_hi}, out_hi, out_lo);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Count=2 Pattern", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs({out_hi, out_hi}, out_hi, out_lo);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Count=3 Pattern", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs({out_lo, out_lo}, out_hi, out_lo);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Rollover Check", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs({out_hi, out_lo}, out_hi, out_lo);
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
        input [15:0] expected_final_out;
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        begin
            if (expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: final_out=%h, out_hi=%h, out_lo=%h",
                         final_out, out_hi, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_out=%h, out_hi=%h, out_lo=%h",
                         expected_final_out, expected_out_hi, expected_out_lo);
                $display("  Got:      final_out=%h, out_hi=%h, out_lo=%h",
                         final_out, out_hi, out_lo);
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
        $dumpvars(0,clk, reset, final_out, out_hi, out_lo);
    end

endmodule
