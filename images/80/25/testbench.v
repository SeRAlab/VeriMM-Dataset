`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    reg select;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .select(select),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        d = 0;
        select = 0;
        @(negedge clk);
        #2 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        select = 0;
        #2;
        $display("Testcase 001: Reset check (Mode 1)");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        select = 1;
        #2;
        $display("Testcase 002: Reset check (Mode 2 Sum)");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        d = 8'hA5;
        select = 0;
        @(negedge clk);
        #2;
        $display("Testcase 003: Mode 1 capture d=A5");
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        d = 8'h0F;
        select = 1;
        @(negedge clk);
        #2;
        $display("Testcase 004: Mode 2 sum check (0F + 0F)");
        #1;

        check_outputs(8'h1E);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        select = 1;
        d = 8'h55;
        @(negedge clk);
        #2 d = 8'hAA;
        @(negedge clk);
        #2;
        $display("Testcase 005: Mode 2 XOR multi-cycle toggle (AA + FF)");
        #1;

        check_outputs(8'hA9);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        d = 8'h01;
        @(negedge clk);
        #2;
        select = 0;
        #1;
        if (q == 8'h01) begin
            select = 1;
            #1;
            $display("Testcase 006: Mode switching check");
            #1;

            check_outputs(8'h02);
        end else begin
            $display("Testcase 006: FAILED at initial Mode 1 check");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        d = 8'h80;
        select = 1;
        @(negedge clk);
        #2;
        $display("Testcase 007: Overflow addition check (80 + 80)");
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, reset, select, q);
    end

endmodule
