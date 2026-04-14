`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg signal_a;
    reg signal_b;
    reg signal_c;
    reg signal_d;
    reg signal_e;
    wire combined_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .signal_a(signal_a),
        .signal_b(signal_b),
        .signal_c(signal_c),
        .signal_d(signal_d),
        .signal_e(signal_e),
        .combined_signal(combined_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        signal_a = 0;
        signal_b = 0;
        signal_c = 0;
        signal_d = 0;
        signal_e = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs LOW", test_num);
        signal_a = 0; signal_b = 0; signal_c = 0; signal_d = 0; signal_e = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: One input HIGH (signal_a)", test_num);
        signal_a = 1; signal_b = 0; signal_c = 0; signal_d = 0; signal_e = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Two inputs HIGH (signal_a, signal_b)", test_num);
        signal_a = 1; signal_b = 1; signal_c = 0; signal_d = 0; signal_e = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Three inputs HIGH (signal_a, signal_c, signal_e)", test_num);
        signal_a = 1; signal_b = 0; signal_c = 1; signal_d = 0; signal_e = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Four inputs HIGH (a, b, c, d)", test_num);
        signal_a = 1; signal_b = 1; signal_c = 1; signal_d = 1; signal_e = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: All five inputs HIGH", test_num);
        signal_a = 1; signal_b = 1; signal_c = 1; signal_d = 1; signal_e = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Toggle signal_e only", test_num);
        signal_a = 0; signal_b = 0; signal_c = 0; signal_d = 0; signal_e = 1;
        @(posedge clk);
        #1;
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
        input expected_combined_signal;
        begin
            if (expected_combined_signal === (expected_combined_signal ^ combined_signal ^ expected_combined_signal)) begin
                $display("PASS");
                $display("  Outputs: combined_signal=%b",
                         combined_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: combined_signal=%b",
                         expected_combined_signal);
                $display("  Got:      combined_signal=%b",
                         combined_signal);
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
        $dumpvars(0,clk, signal_a, signal_b, signal_c, signal_d, signal_e, combined_signal);
    end

endmodule
