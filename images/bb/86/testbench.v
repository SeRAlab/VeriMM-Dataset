`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [5:0] load_val;
    reg reset_n;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .load_val(load_val),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 1'b0;
            load = 1'b0;
            load_val = 6'b0;
            @(posedge clk);
            #1;
            reset_n = 1'b1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Reset");
            reset_dut();

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Incrementing");
            reset_dut();

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Synchronous Load");
            reset_dut();
            @(negedge clk);
            load = 1'b1;
            load_val = 6'd42;
            @(posedge clk);
            #1;
            load = 1'b0;
            #1;

            check_outputs(6'd42);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Increment after Load");
            reset_dut();
            @(negedge clk);
            load = 1'b1;
            load_val = 6'd20;
            @(posedge clk);
            @(negedge clk);
            load = 1'b0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd25);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Rollover");
            reset_dut();
            @(negedge clk);
            load = 1'b1;
            load_val = 6'd63;
            @(posedge clk);
            @(negedge clk);
            load = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset Priority over Load");
            reset_dut();
            @(negedge clk);
            reset_n = 1'b0;
            load = 1'b1;
            load_val = 6'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd0);
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
        input [5:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, load, load_val, reset_n, q);
    end

endmodule
