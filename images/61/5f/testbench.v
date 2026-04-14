`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] count_to;
    reg enable;
    reg reset;
    wire [3:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count_to(count_to),
        .enable(enable),
        .reset(reset),
        .leds(leds)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            count_to = 8'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            count_to = 8'd10;
            enable = 1;

            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            count_to = 8'd3;
            enable = 1;

            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            count_to = 8'd10;
            enable = 0;

            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            count_to = 8'd15;
            enable = 1;
            repeat(5) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            count_to = 8'd20;
            enable = 1;

            repeat(16) @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            count_to = 8'd10;
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            enable = 1;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(4'd3);
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
        input [3:0] expected_leds;
        begin
            if (expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: leds=%h",
                         leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leds=%h",
                         expected_leds);
                $display("  Got:      leds=%h",
                         leds);
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
        $dumpvars(0,clk, count_to, enable, reset, leds);
    end

endmodule
