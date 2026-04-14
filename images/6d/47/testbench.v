`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BTN;
    reg clk;
    wire BTN_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BTN(BTN),
        .clk(clk),
        .BTN_OUT(BTN_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            BTN = 0;
            #(DEBOUNCE_TIME + MARGIN);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Short Noise Pulse (40ms)", test_num);
            reset_dut();
            BTN = 1;
            #(40_000_000);
            BTN = 0;
            #(DEBOUNCE_TIME);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Valid Long Press (150ms)", test_num);
            reset_dut();
            BTN = 1;
            #(150_000_000);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Glitchy Press", test_num);
            reset_dut();

            BTN = 1; #1_000_000;
            BTN = 0; #2_000_000;
            BTN = 1; #1_000_000;
            BTN = 0; #2_000_000;

            BTN = 1;
            #(DEBOUNCE_TIME + MARGIN);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Glitchy Release", test_num);
            reset_dut();

            BTN = 1;
            #(DEBOUNCE_TIME + MARGIN);

            if (BTN_OUT !== 1'b1) $display("Error: Failed to reach initial High state for TC4");


            BTN = 0; #5_000_000;
            BTN = 1; #5_000_000;
            BTN = 0; #5_000_000;

            BTN = 0;
            #(DEBOUNCE_TIME + MARGIN);
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
        input expected_BTN_OUT;
        begin
            if (expected_BTN_OUT === (expected_BTN_OUT ^ BTN_OUT ^ expected_BTN_OUT)) begin
                $display("PASS");
                $display("  Outputs: BTN_OUT=%b",
                         BTN_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BTN_OUT=%b",
                         expected_BTN_OUT);
                $display("  Got:      BTN_OUT=%b",
                         BTN_OUT);
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
        $dumpvars(0,BTN, clk, BTN_OUT);
    end

endmodule
