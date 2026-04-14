`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg signal_in;
    wire signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .signal_in(signal_in),
        .signal_out(signal_out)
    );

        task reset_dut;

    begin
        rst_n = 0;
        signal_in = 0;
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Stable High Transition", test_num);
        reset_dut();
        signal_in = 1;
        #T_STABLE;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Filter High Glitch", test_num);
        reset_dut();
        signal_in = 1;
        #T_GLITCH;
        signal_in = 0;
        #T_STABLE;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Stable Low Transition", test_num);
        reset_dut();

        signal_in = 1;
        #T_STABLE;

        signal_in = 0;
        #T_STABLE;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Testcase %03d: Simulate Bouncing Signal", test_num);
        reset_dut();

        for (i = 0; i < 4; i = i + 1) begin
            signal_in = 1; #50000;
            signal_in = 0; #50000;
        end

        signal_in = 1;
        #T_STABLE;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Filter Low Glitch while High", test_num);
        reset_dut();

        signal_in = 1;
        #T_STABLE;

        signal_in = 0;
        #T_GLITCH;
        signal_in = 1;
        #T_STABLE;
        @(posedge clk);
        #1;

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
        input expected_signal_out;
        begin
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%b",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%b",
                         expected_signal_out);
                $display("  Got:      signal_out=%b",
                         signal_out);
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
        $dumpvars(0,signal_in, signal_out);
    end

endmodule
