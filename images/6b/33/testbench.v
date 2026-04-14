`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg signal;
    wire debounced_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .signal(signal),
        .debounced_signal(debounced_signal)
    );

    // Clock generation (10ns period)
    initial begin
        signal = 0;
        forever #5 signal = ~signal;
    end

        task reset_dut;

    begin
        signal = 0;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Short High Glitch", test_num);
        reset_dut();
        @(posedge clk);
        signal = 1;
        repeat(2) @(posedge clk);
        signal = 0;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Stable High Input", test_num);
        reset_dut();
        @(posedge clk);
        signal = 1;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Noisy Fluctuations", test_num);
        reset_dut();
        repeat(5) begin
            signal = 1; repeat(2) @(posedge clk);
            signal = 0; repeat(2) @(posedge clk);
        end
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Return to Low Transition", test_num);
        reset_dut();
        signal = 1;
        repeat(20) @(posedge clk);
        signal = 0;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Interrupted Debounce Counter", test_num);
        reset_dut();
        signal = 1;
        repeat(8) @(posedge clk);
        signal = 0;
        @(posedge clk);
        signal = 1;
        repeat(4) @(posedge clk);
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
        input expected_debounced_signal;
        begin
            if (expected_debounced_signal === (expected_debounced_signal ^ debounced_signal ^ expected_debounced_signal)) begin
                $display("PASS");
                $display("  Outputs: debounced_signal=%b",
                         debounced_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: debounced_signal=%b",
                         expected_debounced_signal);
                $display("  Got:      debounced_signal=%b",
                         debounced_signal);
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
        $dumpvars(0,signal, debounced_signal);
    end

endmodule
