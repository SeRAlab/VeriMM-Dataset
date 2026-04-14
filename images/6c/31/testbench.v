`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BTN_DOWN;
    reg BTN_UP;
    reg ce;
    reg clk;
    wire [7:0] DAT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BTN_DOWN(BTN_DOWN),
        .BTN_UP(BTN_UP),
        .ce(ce),
        .clk(clk),
        .DAT(DAT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            BTN_UP = 0;
            BTN_DOWN = 0;
            ce = 0;
            force dut.DAT = 8'h80;
            @(posedge clk);
            #1;
            release dut.DAT;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic Increment");
            reset_dut();
            ce = 1;
            BTN_UP = 1;
            @(posedge clk);
            #1;
            BTN_UP = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic Decrement");
            reset_dut();
            ce = 1;
            BTN_DOWN = 1;
            @(posedge clk);
            #1;
            BTN_DOWN = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Clock Enable Inhibition");
            reset_dut();
            ce = 0;
            BTN_UP = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Edge Detection Check (Holding Button)");
            reset_dut();
            ce = 1;
            BTN_UP = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Upper Boundary Limit (0xFF)");
            reset_dut();
            force dut.DAT = 8'hFE;
            ce = 1;
            #1;

            BTN_UP = 1; @(posedge clk); #1; BTN_UP = 0; @(posedge clk); #1;

            BTN_UP = 1; @(posedge clk); #1; BTN_UP = 0; @(posedge clk); #1;
            release dut.DAT;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Lower Boundary Limit (0x01)");
            reset_dut();
            force dut.DAT = 8'h02;
            ce = 1;
            #1;

            BTN_DOWN = 1; @(posedge clk); #1; BTN_DOWN = 0; @(posedge clk); #1;

            BTN_DOWN = 1; @(posedge clk); #1; BTN_DOWN = 0; @(posedge clk); #1;
            release dut.DAT;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Multiple Distinct Presses");
            reset_dut();
            ce = 1;

            repeat(3) begin
                BTN_UP = 1; @(posedge clk); #1; BTN_UP = 0; @(posedge clk); #1;
            end

            BTN_DOWN = 1; @(posedge clk); #1; BTN_DOWN = 0; @(posedge clk); #1;
            #1;

            check_outputs(8'h82);
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
        input [7:0] expected_DAT;
        begin
            if (expected_DAT === (expected_DAT ^ DAT ^ expected_DAT)) begin
                $display("PASS");
                $display("  Outputs: DAT=%h",
                         DAT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DAT=%h",
                         expected_DAT);
                $display("  Got:      DAT=%h",
                         DAT);
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
        $dumpvars(0,BTN_DOWN, BTN_UP, ce, clk, DAT);
    end

endmodule
