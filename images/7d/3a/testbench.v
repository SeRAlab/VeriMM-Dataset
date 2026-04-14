`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] threshVal;
    wire [3:0] count;
    wire thr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .threshVal(threshVal),
        .count(count),
        .thr(thr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Post-Reset Initial State (threshVal=10)", test_num);
            reset_dut();
            threshVal = 4'd10;
            #1;
            #1;

            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Normal Increment 1 to 2", test_num);
            reset_dut();
            threshVal = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reaching threshold (threshVal=3)", test_num);
            reset_dut();
            threshVal = 4'd3;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rollover from threshold to 0", test_num);
            reset_dut();
            threshVal = 4'd3;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Increment from 0 back to 1", test_num);
            reset_dut();
            threshVal = 4'd3;
            repeat(3) @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Immediate threshold (threshVal=1)", test_num);
            reset_dut();
            threshVal = 4'd1;
            #1;
            #1;

            check_outputs(4'd1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rollover from threshVal=1", test_num);
            reset_dut();
            threshVal = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Long count to threshVal=15", test_num);
            reset_dut();
            threshVal = 4'd15;
            repeat(14) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous reset during operation", test_num);
            reset_dut();
            threshVal = 4'd10;
            repeat(5) @(posedge clk);
            reset = 1;
            #5;
            reset = 0;
            #1;
            #1;

            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Dynamic threshVal change", test_num);
            reset_dut();
            threshVal = 4'd10;
            repeat(4) @(posedge clk);
            threshVal = 4'd5;
            #1;
            #1;

            check_outputs(4'd5, 1'b1);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_count;
        input expected_thr;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_thr === (expected_thr ^ thr ^ expected_thr)) begin
                $display("PASS");
                $display("  Outputs: count=%h, thr=%b",
                         count, thr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, thr=%b",
                         expected_count, expected_thr);
                $display("  Got:      count=%h, thr=%b",
                         count, thr);
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
        $dumpvars(0,clk, reset, threshVal, count, thr);
    end

endmodule
