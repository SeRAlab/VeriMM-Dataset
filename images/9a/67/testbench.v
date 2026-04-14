`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg start;
    wire TX;
    wire busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .start(start),
        .TX(TX),
        .busy(busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data = 8'h00;

            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Transmitting 8'h55...", test_num);
            reset_dut();
            data = 8'h55;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(11) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Transmitting 8'hAA...", test_num);
            reset_dut();
            data = 8'hAA;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(11) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Transmitting 8'h00...", test_num);
            reset_dut();
            data = 8'h00;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(11) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Transmitting 8'hFF...", test_num);
            reset_dut();
            data = 8'hFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(11) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Transmitting 8'hA5...", test_num);
            reset_dut();
            data = 8'hA5;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(11) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b0);
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
        input expected_TX;
        input expected_busy;
        begin
            if (expected_TX === (expected_TX ^ TX ^ expected_TX) &&
                expected_busy === (expected_busy ^ busy ^ expected_busy)) begin
                $display("PASS");
                $display("  Outputs: TX=%b, busy=%b",
                         TX, busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TX=%b, busy=%b",
                         expected_TX, expected_busy);
                $display("  Got:      TX=%b, busy=%b",
                         TX, busy);
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
        $dumpvars(0,clk, data, start, TX, busy);
    end

endmodule
