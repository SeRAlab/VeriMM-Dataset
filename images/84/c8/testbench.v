`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg reset;
    wire [3:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            load = 0;
            data_in = 4'b0000;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Synchronous Reset");
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Parallel Load");
            reset_dut();
            @(posedge clk);
            data_in = 4'b1011;
            load = 1;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Circular Shift Left (1 bit)");
            reset_dut();
            @(posedge clk);
            data_in = 4'b1000;
            load = 1;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Circular Shift Left (2 bits)");
            reset_dut();
            @(posedge clk);
            data_in = 4'b1100;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset Priority over Load");
            reset_dut();
            @(posedge clk);
            data_in = 4'b1111;
            load = 1;
            reset = 1;
            @(posedge clk);
            reset = 0;
            load = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Full Rotation (4 bits)");
            reset_dut();
            @(posedge clk);
            data_in = 4'b0110;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(4'b0110);
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
        input [3:0] expected_shift_out;
        begin
            if (expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: shift_out=%h",
                         shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_out=%h",
                         expected_shift_out);
                $display("  Got:      shift_out=%h",
                         shift_out);
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
        $dumpvars(0,clk, data_in, load, reset, shift_out);
    end

endmodule
