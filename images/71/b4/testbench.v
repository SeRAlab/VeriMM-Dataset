`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg rst;
    wire fall_out;
    wire rise_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst(rst),
        .fall_out(fall_out),
        .rise_out(rise_out)
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Steady Low State");
            reset_dut();
            in = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Rising Edge Detection");
            reset_dut();
            in = 0;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Falling Edge Detection");
            reset_dut();
            in = 1;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Steady High State");
            reset_dut();
            in = 1;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Rising then Falling");
            reset_dut();
            in = 0;
            @(posedge clk);
            in = 1;
            @(posedge clk);
            in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset mid-operation");
            reset_dut();
            in = 1;
            @(posedge clk);
            rst = 1;
            in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0);
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
        input expected_fall_out;
        input expected_rise_out;
        begin
            if (expected_fall_out === (expected_fall_out ^ fall_out ^ expected_fall_out) &&
                expected_rise_out === (expected_rise_out ^ rise_out ^ expected_rise_out)) begin
                $display("PASS");
                $display("  Outputs: fall_out=%b, rise_out=%b",
                         fall_out, rise_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fall_out=%b, rise_out=%b",
                         expected_fall_out, expected_rise_out);
                $display("  Got:      fall_out=%b, rise_out=%b",
                         fall_out, rise_out);
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
        $dumpvars(0,clk, in, rst, fall_out, rise_out);
    end

endmodule
