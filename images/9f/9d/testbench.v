`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire comp_out;
    wire [3:0] counter_out;
    wire [1:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .comp_out(comp_out),
        .counter_out(counter_out),
        .pos(pos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset state...", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking count = 5...", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd5, 2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking count = 9 (Boundary)...", test_num);
            reset_dut();
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd9, 2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Checking count = 10 (Threshold)...", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd10, 2'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Checking count = 15 (Max)...", test_num);
            reset_dut();
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd15, 2'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Checking rollover (16 cycles)...", test_num);
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd0, 2'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Resetting mid-count from 12...", test_num);
            reset_dut();
            repeat(12) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            #1;

            check_outputs(1'b0, 4'd0, 2'd0);
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
        input expected_comp_out;
        input [3:0] expected_counter_out;
        input [1:0] expected_pos;
        begin
            if (expected_comp_out === (expected_comp_out ^ comp_out ^ expected_comp_out) &&
                expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: comp_out=%b, counter_out=%h, pos=%h",
                         comp_out, counter_out, pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp_out=%b, counter_out=%h, pos=%h",
                         expected_comp_out, expected_counter_out, expected_pos);
                $display("  Got:      comp_out=%b, counter_out=%h, pos=%h",
                         comp_out, counter_out, pos);
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
        $dumpvars(0,clk, reset, comp_out, counter_out, pos);
    end

endmodule
