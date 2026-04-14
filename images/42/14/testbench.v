`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg accClr_en;
    reg clk;
    reg [15:0] din;
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
            clk = 0;
            din = 0;
            tapWeight = 0;
            trig = 0;
            @(posedge clk);
            #1;
            accClr_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Multiplication");
            reset_dut();
            din = 16'sd100;
            tapWeight = 7'sd2;
            trig = 1;
            @(posedge clk);
            #1;
            trig = 0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd200, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Multiple Accumulations");
            reset_dut();


            din = 16'sd100;
            tapWeight = 7'sd10;
            trig = 1;
            @(posedge clk);
            #1;
            trig = 0;
            repeat(2) @(posedge clk);


            din = 16'sd50;
            tapWeight = 7'sd5;
            trig = 1;
            @(posedge clk);
            #1;
            trig = 0;
            repeat(2) @(posedge clk);

            #1;
            #1;

            check_outputs(16'sd1250, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Positive Overflow Detection");
            reset_dut();
            din = 16'sd1000;
            tapWeight = 7'sd40;
            trig = 1;
            @(posedge clk);
            #1;
            trig = 0;
            repeat(2) @(posedge clk);
            #1;


            if (oflowDetect == 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Overflow detected correctly");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Overflow NOT detected");
            end
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Negative Overflow Detection");
            reset_dut();
            din = -16'sd1000;
            tapWeight = 7'sd40;
            trig = 1;
            @(posedge clk);
            #1;
            trig = 0;
            repeat(2) @(posedge clk);
            #1;
            if (oflowDetect == 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Negative overflow detected correctly");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Negative overflow NOT detected");
            end
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Accumulator Clear functionality");
            reset_dut();
            din = 16'sd500;
            tapWeight = 7'sd2;
            trig = 1;
            @(posedge clk);
            #1;
            trig = 0;
            repeat(2) @(posedge clk);


            accClr_en = 1;
            @(posedge clk);
            #1;
            accClr_en = 0;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Trigger Control");
            reset_dut();
            din = 16'sd1234;
            tapWeight = 7'sd10;
            trig = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Negative Tap Weights");
            reset_dut();
            din = 16'sd500;
            tapWeight = -7'sd2;
            trig = 1;
            @(posedge clk);
            #1;
            trig = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd1000, 1'b0);
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
