`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg reset;
    wire [2:0] pe_out;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .pe_out(pe_out),
        .q(q)
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
            in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            in = 8'b1000_0000;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 001: Highest Priority Bit (7)");
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in = 8'b0100_0000;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 002: Priority Bit 6");
            #1;

            check_outputs(3'd6, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in = 8'b1000_0001;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 003: Multiple Bits (7 and 0 active)");
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in = 8'b0000_0010;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 004: Priority Bit 1");
            #1;

            check_outputs(3'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in = 8'b0000_0000;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 005: All Inputs Zero");
            #1;

            check_outputs(3'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            in = 8'b0001_0100;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 006: Mid-range Priority (Bit 4)");
            #1;

            check_outputs(3'd4, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            in = 8'b1000_0000;
            @(posedge clk);
            in = 8'b0000_0010;
            @(posedge clk);
            #1;
            $display("Testcase 007: Delay Tracking (q vs pe_out)");
            #1;

            check_outputs(3'd1, 1'b1);
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
        input [2:0] expected_pe_out;
        input expected_q;
        begin
            if (expected_pe_out === (expected_pe_out ^ pe_out ^ expected_pe_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: pe_out=%h, q=%b",
                         pe_out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pe_out=%h, q=%b",
                         expected_pe_out, expected_q);
                $display("  Got:      pe_out=%h, q=%b",
                         pe_out, q);
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
        $dumpvars(0,clk, in, reset, pe_out, q);
    end

endmodule
