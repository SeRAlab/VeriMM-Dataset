`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg serial_in;
    reg shift_dir;
    wire [7:0] serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .serial_in(serial_in),
        .shift_dir(shift_dir),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            parallel_in = 8'h00;
            serial_in = 0;
            shift_dir = 0;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            load = 1;
            parallel_in = 8'hA5;
            @(posedge clk);
            #1;
            load = 0;
            $display("Testcase 001: Parallel Load 8'hA5");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            load = 1;
            parallel_in = 8'h01;
            @(posedge clk);
            #1;

            load = 0;
            shift_dir = 1;
            serial_in = 0;
            @(posedge clk);
            #1;
            $display("Testcase 002: Shift Left 8'h01 with serial_in=0");
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            load = 1;
            parallel_in = 8'h80;
            @(posedge clk);
            #1;

            load = 0;
            shift_dir = 0;
            serial_in = 0;
            @(posedge clk);
            #1;
            $display("Testcase 003: Shift Right 8'h80 with serial_in=0");
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            load = 1;
            parallel_in = 8'h00;
            @(posedge clk);
            #1;

            load = 0;
            shift_dir = 1;
            serial_in = 1;
            @(posedge clk);
            #1;
            $display("Testcase 004: Shift Left 8'h00 with serial_in=1");
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            load = 1;
            parallel_in = 8'h00;
            @(posedge clk);
            #1;

            load = 0;
            shift_dir = 0;
            serial_in = 1;
            @(posedge clk);
            #1;
            $display("Testcase 005: Shift Right 8'h00 with serial_in=1");
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            load = 1;
            parallel_in = 8'h55;
            @(posedge clk);
            #1;
            load = 0;

            shift_dir = 1;
            serial_in = 1;
            @(posedge clk);
            #1;

            shift_dir = 0;
            serial_in = 0;
            @(posedge clk);
            #1;
            $display("Testcase 006: Multiple shifts (L then R)");
            #1;

            check_outputs(8'h55);
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
        input [7:0] expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%h",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%h",
                         expected_serial_out);
                $display("  Got:      serial_out=%h",
                         serial_out);
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
        $dumpvars(0,clk, load, parallel_in, serial_in, shift_dir, serial_out);
    end

endmodule
