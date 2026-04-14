`timescale 1ns/1ps

module openhmc_sync_fifo_reg_stage_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d_in;
    reg [7:0] d_in_p;
    reg n_full;
    reg p_full;
    reg res_n;
    reg si;
    reg so;
    wire [7:0] d_out;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    openhmc_sync_fifo_reg_stage dut (
        .clk(clk),
        .d_in(d_in),
        .d_in_p(d_in_p),
        .n_full(n_full),
        .p_full(p_full),
        .res_n(res_n),
        .si(si),
        .so(so),
        .d_out(d_out),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
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
        $display("openhmc_sync_fifo_reg_stage Testbench");
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
        input [7:0] expected_d_out;
        input expected_full;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h, full=%b",
                         d_out, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h, full=%b",
                         expected_d_out, expected_full);
                $display("  Got:      d_out=%h, full=%b",
                         d_out, full);
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
        $dumpvars(0,clk, d_in, d_in_p, n_full, p_full, res_n, si, so, d_out, full);
    end

endmodule
