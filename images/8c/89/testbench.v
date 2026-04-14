`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg accClr_en;
    reg clk;
    reg [12:0] din;
    reg [6:0] tapWeight;
    reg trig;
    wire [15:0] dout;
    wire oflowDetect;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .accClr_en(accClr_en),
        .clk(clk),
        .din(din),
        .tapWeight(tapWeight),
        .trig(trig),
        .dout(dout),
        .oflowDetect(oflowDetect)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        accClr_en = 1;
        trig = 0;
        din = 0;
        tapWeight = 0;
        repeat(2) @(posedge clk);
        #1;
        accClr_en = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task drive_sample;

        input signed [12:0] i_din;
        input signed [6:0] i_weight;
        begin
            @(negedge clk);
            din = i_din;
            tapWeight = i_weight;
            trig = 1;
            @(negedge clk);
            trig = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset Check");
        reset_dut();
        #1;

        check_outputs(16'sd0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Basic Positive MAC");
        reset_dut();
        drive_sample(13'sd100, 7'sd5);
        #1;

        check_outputs(16'sd500, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Multi-step MAC");
        reset_dut();
        drive_sample(13'sd100, 7'sd5);
        drive_sample(13'sd20, 7'sd10);
        #1;

        check_outputs(16'sd700, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Clear Mid-Operation");
        reset_dut();
        drive_sample(13'sd100, 7'sd5);
        @(negedge clk);
        accClr_en = 1;
        @(posedge clk);
        #1;
        accClr_en = 0;
        #1;

        check_outputs(16'sd0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Positive Overflow Detection");
        reset_dut();
        drive_sample(13'sd4000, 7'sd10);
        #1;

        check_outputs(16'sh9C40, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Negative Overflow Detection");
        reset_dut();
        drive_sample(-13'sd4000, 7'sd10);
        #1;

        check_outputs(16'sh63C0, 1'b1);
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
        input [15:0] expected_dout;
        input expected_oflowDetect;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_oflowDetect === (expected_oflowDetect ^ oflowDetect ^ expected_oflowDetect)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, oflowDetect=%b",
                         dout, oflowDetect);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, oflowDetect=%b",
                         expected_dout, expected_oflowDetect);
                $display("  Got:      dout=%h, oflowDetect=%b",
                         dout, oflowDetect);
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
        $dumpvars(0,accClr_en, clk, din, tapWeight, trig, dout, oflowDetect);
    end

endmodule
