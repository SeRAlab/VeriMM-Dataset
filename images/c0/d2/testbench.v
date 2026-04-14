`timescale 1ns/1ps

module fm_ififo_tb;

    // Testbench signals (sequential circuit)
    reg clk_core;
    reg [31:0] i_dt;
    reg i_renable;
    reg i_wstrobe;
    reg rst_x;
    wire [31:0] o_dt;
    wire o_empty;
    wire o_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fm_ififo dut (
        .clk_core(clk_core),
        .i_dt(i_dt),
        .i_renable(i_renable),
        .i_wstrobe(i_wstrobe),
        .rst_x(rst_x),
        .o_dt(o_dt),
        .o_empty(o_empty),
        .o_full(o_full)
    );

    // Clock generation (10ns period)
    initial begin
        clk_core = 0;
        forever #5 clk_core = ~clk_core;
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
        $display("fm_ififo Testbench");
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
        input [31:0] expected_o_dt;
        input expected_o_empty;
        input expected_o_full;
        begin
            if (expected_o_dt === (expected_o_dt ^ o_dt ^ expected_o_dt) &&
                expected_o_empty === (expected_o_empty ^ o_empty ^ expected_o_empty) &&
                expected_o_full === (expected_o_full ^ o_full ^ expected_o_full)) begin
                $display("PASS");
                $display("  Outputs: o_dt=%h, o_empty=%b, o_full=%b",
                         o_dt, o_empty, o_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_dt=%h, o_empty=%b, o_full=%b",
                         expected_o_dt, expected_o_empty, expected_o_full);
                $display("  Got:      o_dt=%h, o_empty=%b, o_full=%b",
                         o_dt, o_empty, o_full);
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
        $dumpvars(0,clk_core, i_dt, i_renable, i_wstrobe, rst_x, o_dt, o_empty, o_full);
    end

endmodule
