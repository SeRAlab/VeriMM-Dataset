`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg accClr_en;
    reg clk;
    reg [12:0] din;
    reg oflowClr;
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
        .oflowClr(oflowClr),
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
            oflowClr = 1;
            trig = 0;
            din = 0;
            tapWeight = 0;
            @(posedge clk);
            #1;
            accClr_en = 0;
            oflowClr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Multiplication", test_num);
            reset_dut();
            din = 13'sd100;
            tapWeight = 7'sd5;
            trig = 1;
            @(posedge clk);
            #1 trig = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(16'sd500, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Data Input", test_num);
            reset_dut();
            din = -13'sd50;
            tapWeight = 7'sd10;
            trig = 1;
            @(posedge clk);
            #1 trig = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(-16'sd500, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-cycle Accumulation", test_num);
            reset_dut();
            tapWeight = 7'sd20;


            din = 13'sd100;
            trig = 1;
            @(posedge clk);
            #1 trig = 0;
            repeat(2) @(posedge clk);


            din = 13'sd50;
            #1 trig = 1;
            @(posedge clk);
            #1 trig = 0;

            repeat(4) @(posedge clk);

            #1;


            check_outputs(16'sd3000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Accumulator Clear Logic", test_num);
            reset_dut();
            din = 13'sd100;
            tapWeight = 7'sd10;
            trig = 1;
            @(posedge clk);
            #1 trig = 0;
            repeat(2) @(posedge clk);

            accClr_en = 1;
            @(posedge clk);
            #1 accClr_en = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'sd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Overflow", test_num);
            reset_dut();

            din = 13'sd1000;
            tapWeight = 7'sd40;
            trig = 1;
            @(posedge clk);
            #1 trig = 0;
            repeat(4) @(posedge clk);


            if (oflowDetect === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Overflow Detected");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Overflow Not Detected");
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Overflow", test_num);
            reset_dut();

            din = -13'sd1000;
            tapWeight = 7'sd40;
            trig = 1;
            @(posedge clk);
            #1 trig = 0;
            repeat(4) @(posedge clk);

            if (oflowDetect === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Overflow Detected");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Overflow Not Detected");
            end
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Clear", test_num);
            reset_dut();

            din = 13'sd1000;
            tapWeight = 7'sd40;
            trig = 1;
            @(posedge clk);
            #1 trig = 0;
            repeat(4) @(posedge clk);


            oflowClr = 1;
            @(posedge clk);
            #1 oflowClr = 0;
            repeat(2) @(posedge clk);

            if (oflowDetect === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: Overflow Cleared");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Overflow Sticky");
            end
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
        $dumpvars(0,accClr_en, clk, din, oflowClr, tapWeight, trig, dout, oflowDetect);
    end

endmodule
