`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bunch_strb;
    reg [20:0] charge_in;
    reg clk;
    reg delay_en;
    reg [14:0] signal_in;
    reg store_strb;
    wire [12:0] DSPout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bunch_strb(bunch_strb),
        .charge_in(charge_in),
        .clk(clk),
        .delay_en(delay_en),
        .signal_in(signal_in),
        .store_strb(store_strb),
        .DSPout(DSPout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            charge_in = 0;
            signal_in = 0;
            delay_en = 0;
            store_strb = 0;
            bunch_strb = 1;
            @(posedge clk);
            #1 bunch_strb = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Multiplication (Positive)");
            reset_dut();
            charge_in = 21'sd1000;
            signal_in = 15'sd500;
            delay_en = 0;
            store_strb = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(get_expected(21'sd1000, 15'sd500));
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Signed Multiplication (Negative)");
            reset_dut();
            charge_in = -21'sd1048;
            signal_in = 15'sd200;
            delay_en = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(get_expected(-21'sd1048, 15'sd200));
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Delayed Processing (15 cycles)");
            reset_dut();
            charge_in = 21'sd5000;
            signal_in = 15'sd10;
            delay_en = 1;

            repeat(15) @(posedge clk);
            #1;

            check_outputs(get_expected(21'sd5000, 15'sd10));
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Store Strobe Processing");
            reset_dut();
            charge_in = 21'sd25;
            signal_in = 15'sd40;
            store_strb = 1;
            @(posedge clk);
            store_strb = 0;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(get_expected(21'sd25, 15'sd40));
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bunch Strobe Mid-operation Reset");
            reset_dut();
            charge_in = 21'sd9999;
            signal_in = 15'sd50;
            delay_en = 1;
            repeat(5) @(posedge clk);
            bunch_strb = 1;
            @(posedge clk);
            bunch_strb = 0;
            charge_in = 21'sd0;
            signal_in = 15'sd0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(13'h0);
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
        input [12:0] expected_DSPout;
        begin
            if (expected_DSPout === (expected_DSPout ^ DSPout ^ expected_DSPout)) begin
                $display("PASS");
                $display("  Outputs: DSPout=%h",
                         DSPout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DSPout=%h",
                         expected_DSPout);
                $display("  Got:      DSPout=%h",
                         DSPout);
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
        $dumpvars(0,bunch_strb, charge_in, clk, delay_en, signal_in, store_strb, DSPout);
    end

endmodule
