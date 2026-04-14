`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg parallel_load;
    reg reset;
    reg shift_dir;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .parallel_load(parallel_load),
        .reset(reset),
        .shift_dir(shift_dir),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            parallel_load = 0;
            data_in = 0;
            shift_dir = 0;
            step();
            reset = 0;
            #1;
        end
        endtask
    task step;

        begin
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Parallel Load");
            reset_dut();
            data_in = 4'b1011;
            parallel_load = 1;
            step();
            parallel_load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Shift Left");
            reset_dut();

            data_in = 4'b0001;
            parallel_load = 1;
            step();

            parallel_load = 0;
            shift_dir = 1;
            step();
            step();
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Shift Right");
            reset_dut();

            data_in = 4'b1000;
            parallel_load = 1;
            step();

            parallel_load = 0;
            shift_dir = 0;
            step();
            step();
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Shift Left until empty");
            reset_dut();
            data_in = 4'b1111;
            parallel_load = 1;
            step();
            parallel_load = 0;
            shift_dir = 1;
            repeat(4) step();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset priority over load");
            reset_dut();
            data_in = 4'b1111;
            parallel_load = 1;
            reset = 1;
            step();
            reset = 0;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, parallel_load, reset, shift_dir, data_out);
    end

endmodule
