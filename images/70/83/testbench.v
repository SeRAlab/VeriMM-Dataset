`timescale 1ns/1ps

module clock_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk_50MHz;
    reg rst_n;
    wire clk_1Hz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_divider dut (
        .clk_50MHz(clk_50MHz),
        .rst_n(rst_n),
        .clk_1Hz(clk_1Hz)
    );

    // Clock generation (10ns period)
    initial begin
        clk_50MHz = 0;
        forever #5 clk_50MHz = ~clk_50MHz;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_divider Testbench");
        $display("========================================");


        
        
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
        input expected_clk_1Hz;
        begin
            if (expected_clk_1Hz === (expected_clk_1Hz ^ clk_1Hz ^ expected_clk_1Hz)) begin
                $display("PASS");
                $display("  Outputs: clk_1Hz=%b",
                         clk_1Hz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_1Hz=%b",
                         expected_clk_1Hz);
                $display("  Got:      clk_1Hz=%b",
                         clk_1Hz);
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
        $dumpvars(0,clk_50MHz, rst_n, clk_1Hz);
    end

endmodule
