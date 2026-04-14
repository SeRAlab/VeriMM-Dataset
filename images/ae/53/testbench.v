`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg reset;
    reg sync;
    wire direct_in;
    wire [4:0] trigger_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .reset(reset),
        .sync(sync),
        .direct_in(direct_in),
        .trigger_out(trigger_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sync = 0;
            din = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset state check...");
            reset_dut();


            #1;



            check_outputs(1'b0, 5'b00000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: direct_in passthrough check...");
            reset_dut();
            din = 1;
            #1;

            #1;


            check_outputs(1'b1, 5'b00000);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Single bit shift (din=1)...");
            reset_dut();
            din = 1;
            sync = 1;
            @(posedge clk);
            #2;
            sync = 0;



            #1;




            check_outputs(1'b1, 5'b00001);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Multi-bit shift sequence...");
            reset_dut();
            sync = 1;

            din = 1; @(posedge clk); #1;
            din = 0; @(posedge clk); #1;
            sync = 0;


            #1;



            check_outputs(1'b0, 5'b00010);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Sync control validation...");
            reset_dut();

            sync = 1; din = 1; @(posedge clk); #1;

            sync = 0; din = 0; @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 5'b00001);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Full register shift...");
            reset_dut();
            sync = 1;
            din = 1;
            repeat(5) @(posedge clk);
            #1;
            sync = 0;

            #1;


            check_outputs(1'b1, 5'b11111);
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
        input expected_direct_in;
        input [4:0] expected_trigger_out;
        begin
            if (expected_direct_in === (expected_direct_in ^ direct_in ^ expected_direct_in) &&
                expected_trigger_out === (expected_trigger_out ^ trigger_out ^ expected_trigger_out)) begin
                $display("PASS");
                $display("  Outputs: direct_in=%b, trigger_out=%h",
                         direct_in, trigger_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: direct_in=%b, trigger_out=%h",
                         expected_direct_in, expected_trigger_out);
                $display("  Got:      direct_in=%b, trigger_out=%h",
                         direct_in, trigger_out);
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
        $dumpvars(0,clk, din, reset, sync, direct_in, trigger_out);
    end

endmodule
