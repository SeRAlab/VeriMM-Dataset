`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [49:0] in;
    reg load;
    reg reset;
    reg select;
    wire [49:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .in(in),
        .load(load),
        .reset(reset),
        .select(select),
        .q(q)
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
            enable = 0;
            select = 0;
            in = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Load and Left Rotate");
            reset_dut();
            in = 50'h0000000000001;
            load = 1;
            @(posedge clk); #1;
            load = 0; enable = 1; select = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(50'h3FFFFFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load and Right Rotate");
            reset_dut();
            in = 50'h0000000000002;
            load = 1;
            @(posedge clk); #1;
            load = 0; enable = 1; select = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(50'h0000000000000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: MSB OR Logic triggering ~OR=0");
            reset_dut();
            in = 50'h2000000000000;
            load = 1;
            @(posedge clk); #1;
            load = 0; enable = 1; select = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(50'h3FFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Right Rotation Wrap-around");
            reset_dut();
            in = 50'h0000000000001;
            load = 1;
            @(posedge clk); #1;
            load = 0; enable = 1; select = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(50'h2000000000001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple Rotations");
            reset_dut();
            in = 50'h0000000000001;
            load = 1;
            @(posedge clk); #1;
            load = 0; enable = 1; select = 0;
            @(posedge clk);
            @(posedge clk); #1;
            #1;

            check_outputs(50'h3FFFFFFFFFFFD);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset Verification");
            reset_dut();
            #1;

            check_outputs(50'h0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Enable Disabled Verification");
            reset_dut();
            in = 50'h0000000000001;
            load = 1;
            @(posedge clk); #1;
            load = 0; enable = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(50'h0000000000000);
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
        input [49:0] expected_q;
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
        $dumpvars(0,clk, enable, in, load, reset, select, q);
    end

endmodule
