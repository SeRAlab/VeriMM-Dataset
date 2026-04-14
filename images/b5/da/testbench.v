`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] in_val;
    reg load;
    reg store;
    wire [2:0] level_out;
    wire [10:0] out_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_val(in_val),
        .load(load),
        .store(store),
        .level_out(level_out),
        .out_val(out_val)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            in_val = 11'd0;
            load = 0;
            store = 0;


            repeat(8) begin
                load = 1;
                @(posedge clk);
            end
            load = 0;
            in_val = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("testcase001: Single Store - Pushing value 100");
            reset_dut();
            in_val = 11'd100;
            store = 1;
            load = 0;
            @(posedge clk);
            #1;
            store = 0;

            #1;


            check_outputs(3'd1, 11'd99);
        end
        endtask

    task testcase002;

        begin
            $display("testcase002: Multi Store and Pop");
            reset_dut();

            in_val = 11'd10; store = 1; load = 0; @(posedge clk); #1;

            in_val = 11'd20; store = 1; load = 0; @(posedge clk); #1;

            in_val = 11'd30; store = 1; load = 0; @(posedge clk); #1;

            store = 0; load = 1; @(posedge clk); #1;
            load = 0;

            #1;


            check_outputs(3'd2, 11'd19);
        end
        endtask

    task testcase003;

        begin
            $display("testcase003: Push-Pop-Push sequence");
            reset_dut();

            in_val = 11'd50; store = 1; load = 0; @(posedge clk); #1;

            store = 0; load = 1; @(posedge clk); #1;

            store = 1; load = 0; in_val = 11'd60; @(posedge clk); #1;
            store = 0;

            #1;


            check_outputs(3'd1, 11'd59);
        end
        endtask

    task testcase004;

        begin
            $display("testcase004: Value decrement underflow check (in=0)");
            reset_dut();
            in_val = 11'd0;
            store = 1;
            load = 0;
            @(posedge clk);
            #1;
            store = 0;

            #1;


            check_outputs(3'd1, 11'd2047);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("testcase005: Maximum depth check (7 levels)");
            reset_dut();
            for (i = 1; i <= 7; i = i + 1) begin
                in_val = i;
                store = 1;
                load = 0;
                @(posedge clk);
                #1;
            end
            store = 0;

            #1;


            check_outputs(3'd7, 11'd6);
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
        input [2:0] expected_level_out;
        input [10:0] expected_out_val;
        begin
            if (expected_level_out === (expected_level_out ^ level_out ^ expected_level_out) &&
                expected_out_val === (expected_out_val ^ out_val ^ expected_out_val)) begin
                $display("PASS");
                $display("  Outputs: level_out=%h, out_val=%h",
                         level_out, out_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: level_out=%h, out_val=%h",
                         expected_level_out, expected_out_val);
                $display("  Got:      level_out=%h, out_val=%h",
                         level_out, out_val);
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
        $dumpvars(0,clk, in_val, load, store, level_out, out_val);
    end

endmodule
