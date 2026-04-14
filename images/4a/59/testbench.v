`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg negedge_clk;
    reg rx_din;
    reg rx_resetn;
    wire [5:0] counter_neg;
    wire is_control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .negedge_clk(negedge_clk),
        .rx_din(rx_din),
        .rx_resetn(rx_resetn),
        .counter_neg(counter_neg),
        .is_control(is_control)
    );

    // Clock generation (10ns period)
    initial begin
        negedge_clk = 0;
        forever #5 negedge_clk = ~negedge_clk;
    end

        task reset_dut;

        begin
            rx_resetn = 0;
            rx_din = 0;
            @(posedge negedge_clk);
            @(posedge negedge_clk);
            rx_resetn = 1;
            @(posedge negedge_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(6'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            rx_din = 1;
            repeat(3) @(posedge negedge_clk);

            #1;


            check_outputs(6'd3, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            rx_din = 1;
            repeat(6) @(posedge negedge_clk);
            #1;

            check_outputs(6'd6, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            rx_din = 1;
            repeat(4) @(posedge negedge_clk);
            rx_din = 0;
            @(posedge negedge_clk);
            #1;

            check_outputs(6'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            rx_din = 1;
            repeat(2) @(posedge negedge_clk);
            rx_din = 0;
            @(posedge negedge_clk);
            rx_din = 1;
            repeat(2) @(posedge negedge_clk);
            #1;

            check_outputs(6'd2, 1'b0);
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
        input [5:0] expected_counter_neg;
        input expected_is_control;
        begin
            if (expected_counter_neg === (expected_counter_neg ^ counter_neg ^ expected_counter_neg) &&
                expected_is_control === (expected_is_control ^ is_control ^ expected_is_control)) begin
                $display("PASS");
                $display("  Outputs: counter_neg=%h, is_control=%b",
                         counter_neg, is_control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_neg=%h, is_control=%b",
                         expected_counter_neg, expected_is_control);
                $display("  Got:      counter_neg=%h, is_control=%b",
                         counter_neg, is_control);
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
        $dumpvars(0,negedge_clk, rx_din, rx_resetn, counter_neg, is_control);
    end

endmodule
