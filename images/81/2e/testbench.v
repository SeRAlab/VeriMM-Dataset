`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [35:0] bv_1;
    reg [35:0] bv_2;
    reg [35:0] bv_3;
    reg [35:0] bv_4;
    reg [35:0] bv_5;
    reg [35:0] bv_6;
    reg [35:0] bv_7;
    reg [35:0] bv_8;
    reg bv_in_valid;
    reg clk;
    reg reset;
    wire [35:0] bv_out;
    wire bv_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bv_1(bv_1),
        .bv_2(bv_2),
        .bv_3(bv_3),
        .bv_4(bv_4),
        .bv_5(bv_5),
        .bv_6(bv_6),
        .bv_7(bv_7),
        .bv_8(bv_8),
        .bv_in_valid(bv_in_valid),
        .clk(clk),
        .reset(reset),
        .bv_out(bv_out),
        .bv_out_valid(bv_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            bv_in_valid = 0;
            bv_1 = 36'h0;
            bv_2 = 36'h0;
            bv_3 = 36'h0;
            bv_4 = 36'h0;
            bv_5 = 36'h0;
            bv_6 = 36'h0;
            bv_7 = 36'h0;
            bv_8 = 36'h0;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: All inputs all ones");
            reset_dut();
            bv_in_valid = 1;
            bv_1 = 36'hFFFFFFFFF;
            bv_2 = 36'hFFFFFFFFF;
            bv_3 = 36'hFFFFFFFFF;
            bv_4 = 36'hFFFFFFFFF;
            bv_5 = 36'hFFFFFFFFF;
            bv_6 = 36'hFFFFFFFFF;
            bv_7 = 36'hFFFFFFFFF;
            bv_8 = 36'hFFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(36'hFFFFFFFFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: One input is zero");
            reset_dut();
            bv_in_valid = 1;
            bv_1 = 36'hFFFFFFFFF;
            bv_2 = 36'h000000000;
            bv_3 = 36'hFFFFFFFFF;
            bv_4 = 36'hFFFFFFFFF;
            bv_5 = 36'hFFFFFFFFF;
            bv_6 = 36'hFFFFFFFFF;
            bv_7 = 36'hFFFFFFFFF;
            bv_8 = 36'hFFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(36'h000000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Bitwise pattern test");
            reset_dut();
            bv_in_valid = 1;
            bv_1 = 36'hAAAAAAAAA;
            bv_2 = 36'hAAAAAAAAA;
            bv_3 = 36'hEAAAAAAAA;
            bv_4 = 36'hAAAAAAAAA;
            bv_5 = 36'hAAAAAAAAA;
            bv_6 = 36'hAAAAAAAAA;
            bv_7 = 36'hAAAAAAAAA;
            bv_8 = 36'hAAAAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(36'hAAAAAAAAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: bv_in_valid is low");
            reset_dut();
            bv_in_valid = 0;
            bv_1 = 36'hFFFFFFFFF;
            bv_2 = 36'hFFFFFFFFF;
            bv_3 = 36'hFFFFFFFFF;
            bv_4 = 36'hFFFFFFFFF;
            bv_5 = 36'hFFFFFFFFF;
            bv_6 = 36'hFFFFFFFFF;
            bv_7 = 36'hFFFFFFFFF;
            bv_8 = 36'hFFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(bv_out, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset active");
            reset_dut();
            reset = 0;
            bv_in_valid = 1;
            bv_1 = 36'hFFFFFFFFF;
            bv_2 = 36'hFFFFFFFFF;
            bv_3 = 36'hFFFFFFFFF;
            bv_4 = 36'hFFFFFFFFF;
            bv_5 = 36'hFFFFFFFFF;
            bv_6 = 36'hFFFFFFFFF;
            bv_7 = 36'hFFFFFFFFF;
            bv_8 = 36'hFFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(36'h000000000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Mixed inputs");
            reset_dut();
            bv_in_valid = 1;
            bv_1 = 36'hF0F0F0F0F;
            bv_2 = 36'hFF00FF00F;
            bv_3 = 36'hFFFFFFFFF;
            bv_4 = 36'hFFFFFFFFF;
            bv_5 = 36'hFFFFFFFFF;
            bv_6 = 36'hFFFFFFFFF;
            bv_7 = 36'hFFFFFFFFF;
            bv_8 = 36'hFFFFFFFFF;

            @(posedge clk);
            #2;
            #1;

            check_outputs(36'hF000F000F, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Single bit propagation");
            reset_dut();
            bv_in_valid = 1;
            bv_1 = 36'h000000001;
            bv_2 = 36'h000000001;
            bv_3 = 36'h000000001;
            bv_4 = 36'h000000001;
            bv_5 = 36'h000000001;
            bv_6 = 36'h000000001;
            bv_7 = 36'h000000001;
            bv_8 = 36'h000000001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(36'h000000001, 1'b1);
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
        input [35:0] expected_bv_out;
        input expected_bv_out_valid;
        begin
            if (expected_bv_out === (expected_bv_out ^ bv_out ^ expected_bv_out) &&
                expected_bv_out_valid === (expected_bv_out_valid ^ bv_out_valid ^ expected_bv_out_valid)) begin
                $display("PASS");
                $display("  Outputs: bv_out=%h, bv_out_valid=%b",
                         bv_out, bv_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bv_out=%h, bv_out_valid=%b",
                         expected_bv_out, expected_bv_out_valid);
                $display("  Got:      bv_out=%h, bv_out_valid=%b",
                         bv_out, bv_out_valid);
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
        $dumpvars(0,bv_1, bv_2, bv_3, bv_4, bv_5, bv_6, bv_7, bv_8, bv_in_valid, clk, reset, bv_out, bv_out_valid);
    end

endmodule
