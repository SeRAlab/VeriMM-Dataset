`timescale 1ns/1ps

module wbwatchdog_tb;

    // Testbench signals (sequential circuit)
    reg i_ce;
    reg i_clk;
    reg i_rst;
    reg [31:0] i_timeout;
    wire o_int;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wbwatchdog dut (
        .i_ce(i_ce),
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_timeout(i_timeout),
        .o_int(o_int)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
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
        $display("wbwatchdog Testbench");
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
        input expected_o_int;
        begin
            if (expected_o_int === (expected_o_int ^ o_int ^ expected_o_int)) begin
                $display("PASS");
                $display("  Outputs: o_int=%b",
                         o_int);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_int=%b",
                         expected_o_int);
                $display("  Got:      o_int=%b",
                         o_int);
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
        $dumpvars(0,i_ce, i_clk, i_rst, i_timeout, o_int);
    end

endmodule
