`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_strobe_din;
    wire active_dout;
    wire done_strobe_dout;
    wire enable_dout;
    wire round_shift_dout;
    wire source_dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .start_strobe_din(start_strobe_din),
        .active_dout(active_dout),
        .done_strobe_dout(done_strobe_dout),
        .enable_dout(enable_dout),
        .round_shift_dout(round_shift_dout),
        .source_dout(source_dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_strobe_din = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Start Trigger Response");
            reset_dut();
            @(posedge clk);
            start_strobe_din = 1;
            @(posedge clk);
            start_strobe_din = 0;
            #1;

            #1;


            check_outputs(1, 0, 1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Round Shifting Phase");
            reset_dut();
            @(posedge clk);
            start_strobe_din = 1;
            @(posedge clk);
            start_strobe_din = 0;
            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Sequence Completion");
            reset_dut();
            @(posedge clk);
            start_strobe_din = 1;
            @(posedge clk);
            start_strobe_din = 0;

            repeat (100) begin
                if (done_strobe_dout) break;
                @(posedge clk);
            end
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Reset Interrupt");
            reset_dut();
            @(posedge clk);
            start_strobe_din = 1;
            @(posedge clk);
            start_strobe_din = 0;
            repeat (5) @(posedge clk);
            reset = 1;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0);
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
        input expected_active_dout;
        input expected_done_strobe_dout;
        input expected_enable_dout;
        input expected_round_shift_dout;
        input expected_source_dout;
        begin
            if (expected_active_dout === (expected_active_dout ^ active_dout ^ expected_active_dout) &&
                expected_done_strobe_dout === (expected_done_strobe_dout ^ done_strobe_dout ^ expected_done_strobe_dout) &&
                expected_enable_dout === (expected_enable_dout ^ enable_dout ^ expected_enable_dout) &&
                expected_round_shift_dout === (expected_round_shift_dout ^ round_shift_dout ^ expected_round_shift_dout) &&
                expected_source_dout === (expected_source_dout ^ source_dout ^ expected_source_dout)) begin
                $display("PASS");
                $display("  Outputs: active_dout=%b, done_strobe_dout=%b, enable_dout=%b, round_shift_dout=%b, source_dout=%b",
                         active_dout, done_strobe_dout, enable_dout, round_shift_dout, source_dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_dout=%b, done_strobe_dout=%b, enable_dout=%b, round_shift_dout=%b, source_dout=%b",
                         expected_active_dout, expected_done_strobe_dout, expected_enable_dout, expected_round_shift_dout, expected_source_dout);
                $display("  Got:      active_dout=%b, done_strobe_dout=%b, enable_dout=%b, round_shift_dout=%b, source_dout=%b",
                         active_dout, done_strobe_dout, enable_dout, round_shift_dout, source_dout);
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
        $dumpvars(0,clk, reset, start_strobe_din, active_dout, done_strobe_dout, enable_dout, round_shift_dout, source_dout);
    end

endmodule
