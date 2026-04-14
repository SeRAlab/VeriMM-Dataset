`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] byteenable;
    reg clk;
    reg [23:0] d;
    reg reset_n;
    wire [23:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .byteenable(byteenable),
        .clk(clk),
        .d(d),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        d = 24'h0;
        byteenable = 4'h0;
        step();
        reset_n = 1;
        step();
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
        reset_dut();
        $display("Testcase 001: Reset Check");
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Full Byte Enable (All bytes)");
        d = 24'hABCDEF;
        byteenable = 4'b0111;
        step();
        #1;

        check_outputs(24'hABCDEF);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Selective Byte Enable [0]");
        d = 24'h112233;
        byteenable = 4'b0001;
        step();
        #1;

        check_outputs(24'h000033);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Selective Byte Enable [1]");
        d = 24'h112233;
        byteenable = 4'b0010;
        step();
        #1;

        check_outputs(24'h002200);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Selective Byte Enable [2]");
        d = 24'h112233;
        byteenable = 4'b0100;
        step();
        #1;

        check_outputs(24'h110000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: Sequential Accumulative Write");

        d = 24'hAAAAAA;
        byteenable = 4'b0001;
        step();

        d = 24'hBBBBBB;
        byteenable = 4'b0010;
        step();

        d = 24'hCCCCCC;
        byteenable = 4'b0100;
        step();
        #1;

        check_outputs(24'hCCBBAA);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Testcase 007: Byte Enable zero check");

        d = 24'hFFFFFF;
        byteenable = 4'b0111;
        step();

        d = 24'h000000;
        byteenable = 4'b0000;
        step();
        #1;

        check_outputs(24'hFFFFFF);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        $display("Testcase 008: Overwrite middle byte only");
        d = 24'hFFFFFF;
        byteenable = 4'b0111;
        step();
        d = 24'h000000;
        byteenable = 4'b0010;
        step();
        #1;

        check_outputs(24'hFF00FF);
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
        testcase008();
        
        
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
        input [23:0] expected_q;
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
        $dumpvars(0,byteenable, clk, d, reset_n, q);
    end

endmodule
