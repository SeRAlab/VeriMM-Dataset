`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg reset;
    wire [3:0] data_out;

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
            load = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase 002: Basic Count (3 Cycles)");
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase 003: Long Count (10 Cycles)");
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase 004: Load Value 5");
            reset_dut();
            data_in = 4'h5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase 005: Load A and Count 5 cycles");
            reset_dut();
            data_in = 4'hA;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nRunning Testcase 006: Overflow Check (F -> 0)");
            reset_dut();
            data_in = 4'hF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nRunning Testcase 007: Load F Latency Check");
            reset_dut();
            data_in = 4'hF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
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
        $dumpvars(0,clk, data_in, load, reset, data_out);
    end

endmodule
