`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [15:0] pseudorand;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pseudorand(pseudorand)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Initial State (Startup to 0)", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Zero-State Persistence (0 ^ 0 = 0)", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR Logic Check - Tap Bit 8 (1 ^ 0 = 1)", test_num);
            reset_dut();

            force dut.pseudorand = 16'h0100;
            @(posedge clk);
            #1;
            release dut.pseudorand;

            #1;


            check_outputs(16'h8080);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR Logic Check - Tap Bit 4 (0 ^ 1 = 1)", test_num);
            reset_dut();

            force dut.pseudorand = 16'h0010;
            @(posedge clk);
            #1;
            release dut.pseudorand;

            #1;


            check_outputs(16'h8008);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR Logic Check - Both Taps (1 ^ 1 = 0)", test_num);
            reset_dut();

            force dut.pseudorand = 16'h0110;
            @(posedge clk);
            #1;
            release dut.pseudorand;

            #1;


            check_outputs(16'h0088);
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
        input [15:0] expected_pseudorand;
        begin
            if (expected_pseudorand === (expected_pseudorand ^ pseudorand ^ expected_pseudorand)) begin
                $display("PASS");
                $display("  Outputs: pseudorand=%h",
                         pseudorand);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pseudorand=%h",
                         expected_pseudorand);
                $display("  Got:      pseudorand=%h",
                         pseudorand);
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
        $dumpvars(0,clk, pseudorand);
    end

endmodule
