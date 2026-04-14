`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg rst;
    reg [15:0] rx;
    wire [7:0] data_out;
    wire [15:0] tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .rst(rst),
        .rx(rx),
        .data_out(data_out),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data = 8'h00;
            rx = 16'h0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            $display("Reset completed.");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: State 0 - Pass-through");
            reset_dut();
            data = 8'hA5;
            rx = 16'h003C;

            #1;


            check_outputs(8'h3C, 16'h00A5);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: State 1 - Inversion");
            reset_dut();

            @(posedge clk);
            data = 8'hAA;
            rx = 16'h00FF;


            #1;



            check_outputs(8'h00, 16'hFF55);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: State 2 - Zeroing");
            reset_dut();

            @(posedge clk);
            @(posedge clk);
            data = 8'hFF;
            rx = 16'hFFFF;

            #1;


            check_outputs(8'h00, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: FSM Cycle - Back to State 0");
            reset_dut();

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            data = 8'h12;
            rx = 16'h0034;
            #1;

            check_outputs(8'h34, 16'h0012);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Mid-operation Reset");
            reset_dut();
            @(posedge clk);
            rst = 1;
            #2;
            data = 8'h55;
            rx = 16'h1122;


            #1;



            check_outputs(8'h00, 16'h0000);
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
        input [7:0] expected_data_out;
        input [15:0] expected_tx;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, tx=%h",
                         data_out, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, tx=%h",
                         expected_data_out, expected_tx);
                $display("  Got:      data_out=%h, tx=%h",
                         data_out, tx);
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
        $dumpvars(0,clk, data, rst, rx, data_out, tx);
    end

endmodule
