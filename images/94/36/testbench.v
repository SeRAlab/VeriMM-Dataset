`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg rst_n;
    wire [7:0] max_index;
    wire [7:0] max_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .max_index(max_index),
        .max_value(max_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            @(posedge clk);
            #2 rst_n = 1;
            $display("DUT Reset at time %0t", $time);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset State Check");
            rst_n = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Max at Index 1 (High Byte)");
            reset_dut();

            data_in = 16'hA015;
            @(posedge clk);
            #1;

            check_outputs(8'd1, 8'hA0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Max at Index 0 (Low Byte)");
            reset_dut();

            data_in = 16'h2277;
            @(posedge clk);
            #1;

            check_outputs(8'd0, 8'h77);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Equal values tie check");
            reset_dut();
            data_in = 16'hFFFF;
            @(posedge clk);


            #1;



            check_outputs(8'd0, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Zero Values");
            reset_dut();
            data_in = 16'h0000;
            @(posedge clk);
            #1;

            check_outputs(8'd0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Boundary values (0x00 vs 0x01)");
            reset_dut();
            data_in = 16'h0100;
            @(posedge clk);
            #1;

            check_outputs(8'd1, 8'h01);
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
        input [7:0] expected_max_index;
        input [7:0] expected_max_value;
        begin
            if (expected_max_index === (expected_max_index ^ max_index ^ expected_max_index) &&
                expected_max_value === (expected_max_value ^ max_value ^ expected_max_value)) begin
                $display("PASS");
                $display("  Outputs: max_index=%h, max_value=%h",
                         max_index, max_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_index=%h, max_value=%h",
                         expected_max_index, expected_max_value);
                $display("  Got:      max_index=%h, max_value=%h",
                         max_index, max_value);
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
        $dumpvars(0,clk, data_in, rst_n, max_index, max_value);
    end

endmodule
