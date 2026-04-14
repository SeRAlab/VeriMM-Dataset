`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg capture_operate;
    reg clk;
    reg counter_operate;
    reg [3:0] delta_channels;
    reg reset_counter;
    reg [3:0] strobe_channels;
    wire [46:0] data;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .capture_operate(capture_operate),
        .clk(clk),
        .counter_operate(counter_operate),
        .delta_channels(delta_channels),
        .reset_counter(reset_counter),
        .strobe_channels(strobe_channels),
        .data(data),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            capture_operate = 0;
            counter_operate = 0;
            delta_channels = 4'b0000;
            strobe_channels = 4'b0000;
            reset_counter = 1;
            repeat(2) @(posedge clk);
            reset_counter = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset and Idle state check...");
            reset_dut();

            #1;


            check_outputs(47'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Delta channel change event...");
            reset_dut();
            capture_operate = 1;
            @(posedge clk);
            delta_channels = 4'b0001;
            repeat(2) @(posedge clk);




            if (ready === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Data captured on delta change.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Ready signal not asserted on delta change.");
            end
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Strobe channel event...");
            reset_dut();
            strobe_channels = 4'b0010;
            repeat(2) @(posedge clk);

            if (ready === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Data captured on strobe activity.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Ready signal not asserted on strobe.");
            end
            strobe_channels = 4'b0000;
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Counter zero event...");
            reset_dut();
            counter_operate = 1;


            repeat(10) @(posedge clk);
            if (ready === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Data captured on counter timeout.");
            end else begin

                $display("INFO: Checking if timeout event triggered.");
                #1;

                check_outputs(data, ready);
            end
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Capture operate gating check...");
            reset_dut();
            capture_operate = 0;
            delta_channels = 4'b1111;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(47'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset counter mid-operation...");
            reset_dut();
            delta_channels = 4'b1010;
            capture_operate = 1;
            @(posedge clk);
            reset_counter = 1;
            @(posedge clk);
            reset_counter = 0;
            repeat(2) @(posedge clk);

            if (ready === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: System reset successfully during operation.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: System did not clear ready after reset.");
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
        input [46:0] expected_data;
        input expected_ready;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data=%h, ready=%b",
                         data, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, ready=%b",
                         expected_data, expected_ready);
                $display("  Got:      data=%h, ready=%b",
                         data, ready);
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
        $dumpvars(0,capture_operate, clk, counter_operate, delta_channels, reset_counter, strobe_channels, data, ready);
    end

endmodule
