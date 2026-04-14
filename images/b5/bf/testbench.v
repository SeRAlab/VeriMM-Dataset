`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dataIn;
    reg enable;
    reg micData;
    reg rst;
    wire [15:0] dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dataIn(dataIn),
        .enable(enable),
        .micData(micData),
        .rst(rst),
        .dataOut(dataOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            dataIn = 0;
            micData = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task load_sample;

        input [15:0] sample;
        integer i;
        begin
            enable = 1;
            for (i = 15; i >= 0; i = i - 1) begin
                micData = sample[i];
                @(posedge clk);
            end
            enable = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: Reset State Check");
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Single Sample Load and Playback");
            reset_dut();


            load_sample(16'hA5A5);


            dataIn = 1;
            @(posedge clk);
            dataIn = 0;


            @(posedge clk);
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Multi-Sample Sequential Playback");
            reset_dut();


            load_sample(16'h1234);
            load_sample(16'h5678);
            load_sample(16'h9ABC);


            dataIn = 1;
            @(posedge clk);
            dataIn = 0;


            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(16'h9ABC);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Test Case 004: Enable Signal Gating Check");
            reset_dut();


            enable = 0;
            for (i = 0; i < 16; i = i + 1) begin
                micData = 1;
                @(posedge clk);
            end


            load_sample(16'hFFFF);


            dataIn = 1;
            @(posedge clk);
            dataIn = 0;


            @(posedge clk);
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_dataOut;
        begin
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%h",
                         dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%h",
                         expected_dataOut);
                $display("  Got:      dataOut=%h",
                         dataOut);
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
        $dumpvars(0,clk, dataIn, enable, micData, rst, dataOut);
    end

endmodule
