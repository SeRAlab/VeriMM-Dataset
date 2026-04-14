`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg scan_clk;
    reg scan_mode;
    reg scan_rst;
    reg wkup_clear;
    reg wkup_event;
    wire wkup_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .scan_clk(scan_clk),
        .scan_mode(scan_mode),
        .scan_rst(scan_rst),
        .wkup_clear(wkup_clear),
        .wkup_event(wkup_event),
        .wkup_out(wkup_out)
    );

        task reset_dut;

        begin
            scan_rst = 1;
            scan_mode = 0;
            wkup_clear = 0;
            wkup_event = 0;
            @(posedge scan_clk);
            #1 scan_rst = 0;
            @(posedge scan_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge scan_clk);
            wkup_event = 1;
            @(posedge scan_clk);
            @(negedge scan_clk);
            wkup_event = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(negedge scan_clk);
            wkup_event = 1;
            @(posedge scan_clk);

            @(negedge scan_clk);
            wkup_event = 0;
            wkup_clear = 1;
            @(posedge scan_clk);
            @(negedge scan_clk);
            wkup_clear = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge scan_clk);
            wkup_event = 1;
            @(posedge scan_clk);
            @(negedge scan_clk);
            wkup_event = 0;
            repeat(3) @(posedge scan_clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge scan_clk);
            wkup_event = 1;
            wkup_clear = 1;
            @(posedge scan_clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge scan_clk);
            wkup_event = 1;
            @(posedge scan_clk);
            @(negedge scan_clk);
            scan_rst = 1;
            @(posedge scan_clk);
            #1;

            check_outputs(1'b0);
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
        input expected_wkup_out;
        begin
            if (expected_wkup_out === (expected_wkup_out ^ wkup_out ^ expected_wkup_out)) begin
                $display("PASS");
                $display("  Outputs: wkup_out=%b",
                         wkup_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wkup_out=%b",
                         expected_wkup_out);
                $display("  Got:      wkup_out=%b",
                         wkup_out);
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
        $dumpvars(0,scan_clk, scan_mode, scan_rst, wkup_clear, wkup_event, wkup_out);
    end

endmodule
