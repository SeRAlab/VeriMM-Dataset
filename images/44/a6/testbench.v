`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg in_valid;
    reg out_ready;
    reg reset_n;
    wire in_ready;
    wire [7:0] out_data;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .in_valid(in_valid),
        .out_ready(out_ready),
        .reset_n(reset_n),
        .in_ready(in_ready),
        .out_data(out_data),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            in_valid = 0;
            in_data = 0;
            out_ready = 1;
            repeat(2) @(posedge clk);
            #1 reset_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset and Initial State");
            reset_dut();

            #1;


            check_outputs(1'b1, IDLE_CHAR, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Normal Data Transmission");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            in_data = 8'hAA;
            out_ready = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Escape Sequence for Idle Character");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            in_data = IDLE_CHAR;
            out_ready = 1;


            @(posedge clk);
            #1;
            if (out_data == ESCAPE_CHAR && in_ready == 0) begin
                $display("  Cycle 1: Correctly inserted Escape character");
            end


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, IDLE_CHAR, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Escape Sequence for Escape Character");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            in_data = ESCAPE_CHAR;
            out_ready = 1;


            @(posedge clk);
            #1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, ESCAPE_CHAR, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Idle Insertion when in_valid is Low");
            reset_dut();
            @(posedge clk);
            in_valid = 0;
            out_ready = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, IDLE_CHAR, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Backpressure Handling");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            in_data = 8'hBB;
            out_ready = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'hBB, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Successive Normal and Escape Data");
            reset_dut();
            @(posedge clk);
            in_valid = 1; in_data = 8'h11; out_ready = 1;
            @(posedge clk);
            in_valid = 1; in_data = IDLE_CHAR;
            @(posedge clk);
            @(posedge clk);
            in_valid = 1; in_data = 8'h22;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h22, 1'b1);
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
        input expected_in_ready;
        input [7:0] expected_out_data;
        input expected_out_valid;
        begin
            if (expected_in_ready === (expected_in_ready ^ in_ready ^ expected_in_ready) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: in_ready=%b, out_data=%h, out_valid=%b",
                         in_ready, out_data, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_ready=%b, out_data=%h, out_valid=%b",
                         expected_in_ready, expected_out_data, expected_out_valid);
                $display("  Got:      in_ready=%b, out_data=%h, out_valid=%b",
                         in_ready, out_data, out_valid);
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
        $dumpvars(0,clk, in_data, in_valid, out_ready, reset_n, in_ready, out_data, out_valid);
    end

endmodule
