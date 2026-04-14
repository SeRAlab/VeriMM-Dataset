`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg enable;
    reg res;
    reg [7:0] sclk;
    reg sdata;
    wire [7:0] samples;
    wire [7:0] trans;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .res(res),
        .sclk(sclk),
        .sdata(sdata),
        .samples(samples),
        .trans(trans)
    );

    // Clock generation (10ns period)
    initial begin
        res = 0;
        forever #5 res = ~res;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;

            force res = 1;
            enable = 0;
            sclk = 8'h00;
            sdata = 0;
            #20;
            force res = 0;
            #10;
            release res;
        end
        endtask
    task sample_all;

        input [7:0] value;
        integer i, stage;
        begin

            for (stage = 0; stage < 4; stage = stage + 1) begin
                for (i = 0; i < 8; i = i + 1) begin
                    sdata = value[i];
                    sclk[i] = 1;
                    #10;
                    sclk[i] = 0;
                    #10;
                end
            end
        end
        endtask

    task testcase001;

        begin
            $display("\nTestcase 001: Initial State after Reset");
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Sampling 0xFF with Enable High");
            reset_dut();
            enable = 1;
            sample_all(8'hFF);
            #20;
            #1;

            check_outputs(8'hFF, 8'h80);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Sampling 0xAA (10101010)");
            reset_dut();
            enable = 1;
            sample_all(8'hAA);
            #20;
            #1;

            check_outputs(8'hAA, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Sampling 0x55 (01010101)");
            reset_dut();
            enable = 1;
            sample_all(8'h55);
            #20;
            #1;

            check_outputs(8'h55, 8'h7F);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Check Enable Low functionality");
            reset_dut();
            enable = 0;
            sample_all(8'hFF);
            #20;

            #1;


            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Sampling 0x0F (00001111)");
            reset_dut();
            enable = 1;
            sample_all(8'h0F);
            #20;
            #1;

            check_outputs(8'h0F, 8'h08);
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
        input [7:0] expected_samples;
        input [7:0] expected_trans;
        begin
            if (expected_samples === (expected_samples ^ samples ^ expected_samples) &&
                expected_trans === (expected_trans ^ trans ^ expected_trans)) begin
                $display("PASS");
                $display("  Outputs: samples=%h, trans=%h",
                         samples, trans);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: samples=%h, trans=%h",
                         expected_samples, expected_trans);
                $display("  Got:      samples=%h, trans=%h",
                         samples, trans);
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
        $dumpvars(0,enable, res, sclk, sdata, samples, trans);
    end

endmodule
