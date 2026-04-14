`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] hdb3_in;
    reg rst;
    reg valid;
    wire checkv_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hdb3_in(hdb3_in),
        .rst(rst),
        .valid(valid),
        .checkv_out(checkv_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            hdb3_in = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Normal Alternating Sequence");
            reset_dut();
            valid = 1;
            hdb3_in = 2'b01; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b11; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b01; @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Detection of 4 Consecutive Zeros");
            reset_dut();
            valid = 1;
            hdb3_in = 2'b01; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Consecutive Same-Polarity Pulses");
            reset_dut();
            valid = 1;
            hdb3_in = 2'b01; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b01; @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Valid Signal Gating");
            reset_dut();
            valid = 1;
            hdb3_in = 2'b01; @(posedge clk);
            valid = 0;
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            valid = 1;
            hdb3_in = 2'b11; @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Extended Zero Sequence Detection");
            reset_dut();
            valid = 1;
            hdb3_in = 2'b11; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            hdb3_in = 2'b00; @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
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
        input expected_checkv_out;
        begin
            if (expected_checkv_out === (expected_checkv_out ^ checkv_out ^ expected_checkv_out)) begin
                $display("PASS");
                $display("  Outputs: checkv_out=%b",
                         checkv_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checkv_out=%b",
                         expected_checkv_out);
                $display("  Got:      checkv_out=%b",
                         checkv_out);
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
        $dumpvars(0,clk, hdb3_in, rst, valid, checkv_out);
    end

endmodule
