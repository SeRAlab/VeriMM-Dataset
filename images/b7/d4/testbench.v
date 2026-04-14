`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg enable;
    reg load;
    reg rst;
    reg shift_dir;
    wire [3:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .load(load),
        .rst(rst),
        .shift_dir(shift_dir),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            load = 0;
            shift_dir = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset and Empty Flag check...");
            reset_dut();

            #1;


            check_outputs(4'b0000, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load Data and Full Flag check...");
            reset_dut();
            data_in = 4'b1111;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1 load = 0;
            enable = 0;

            #1;


            check_outputs(4'b1111, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Left Shift (dir=1)...");
            reset_dut();

            data_in = 4'b0001;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1 load = 0;
            shift_dir = 1;
            @(posedge clk);
            #1 enable = 0;

            #1;


            check_outputs(4'b0010, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Right Shift (dir=0)...");
            reset_dut();

            data_in = 4'b1000;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1 load = 0;
            shift_dir = 0;
            @(posedge clk);
            #1 enable = 0;

            #1;


            check_outputs(4'b0100, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Shift until Empty...");
            reset_dut();
            data_in = 4'b0010;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1 load = 0;
            shift_dir = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 enable = 0;
            #1;

            check_outputs(4'b0000, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Enable=0 verification...");
            reset_dut();
            data_in = 4'b1010;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1 load = 0;
            enable = 0;
            shift_dir = 1;
            @(posedge clk);
            @(posedge clk);
            #1
            #1;

            check_outputs(4'b1010, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Load priority check...");
            reset_dut();
            data_in = 4'b1010;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1
            data_in = 4'b0101;
            load = 1;
            shift_dir = 1;
            @(posedge clk);
            #1 enable = 0;

            #1;


            check_outputs(4'b0101, 1'b0, 1'b0);
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
        input [3:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clk, data_in, enable, load, rst, shift_dir, data_out, empty, full);
    end

endmodule
