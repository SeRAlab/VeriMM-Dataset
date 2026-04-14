`timescale 1ns/1ps

module pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll dut (
        .clk_ref(clk_ref),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

    begin
        reset = 1;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Checking reset state...");
        reset = 1;
        #50;
        #1;

        check_outputs(1'b0);
        reset = 0;
        #10;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Checking start-up behavior after reset...");
        reset_dut();

        repeat (5) @(posedge clk_ref);
        #2;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Checking frequency stability...");
        reset_dut();

        repeat (12) @(posedge clk_ref);
        #2;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Sampling phase at 20 cycles...");
        reset_dut();
        repeat (20) @(posedge clk_ref);
        #2;
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
        $display("pll Testbench");
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_ref, reset, clk_out);
    end

endmodule
