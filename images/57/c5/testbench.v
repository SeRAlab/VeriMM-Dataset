`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg shift;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .shift(shift),
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
            shift = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Fill 4 elements...");
            reset_dut();

            data_in = 8'hAA; shift = 1; @(posedge clk);
            data_in = 8'hBB; shift = 1; @(posedge clk);
            data_in = 8'hCC; shift = 1; @(posedge clk);
            data_in = 8'hDD; shift = 1; @(posedge clk);
            shift = 0;
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Overwrite first element (5 shifts)...");
            reset_dut();
            data_in = 8'h11; shift = 1; @(posedge clk);
            data_in = 8'h22; shift = 1; @(posedge clk);
            data_in = 8'h33; shift = 1; @(posedge clk);
            data_in = 8'h44; shift = 1; @(posedge clk);
            data_in = 8'h55; shift = 1; @(posedge clk);
            shift = 0;
            #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Reset behavior...");
            reset_dut();
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Shifts with idle cycles...");
            reset_dut();
            data_in = 8'hA1; shift = 1; @(posedge clk);
            shift = 0; repeat(2) @(posedge clk);
            data_in = 8'hB2; shift = 1; @(posedge clk);
            data_in = 8'hC3; shift = 1; @(posedge clk);
            shift = 0; @(posedge clk);
            data_in = 8'hD4; shift = 1; @(posedge clk);
            shift = 0;
            #1;

            #1;


            check_outputs(8'hA1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Two full cycles of shifting...");
            reset_dut();

            data_in = 8'h01; shift = 1; @(posedge clk);
            data_in = 8'h02; shift = 1; @(posedge clk);
            data_in = 8'h03; shift = 1; @(posedge clk);
            data_in = 8'h04; shift = 1; @(posedge clk);

            data_in = 8'h05; shift = 1; @(posedge clk);
            data_in = 8'h06; shift = 1; @(posedge clk);
            data_in = 8'h07; shift = 1; @(posedge clk);
            data_in = 8'h08; shift = 1; @(posedge clk);
            shift = 0;
            #1;

            #1;


            check_outputs(8'h05);
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
        $dumpvars(0,clk, data_in, reset, shift, data_out);
    end

endmodule
