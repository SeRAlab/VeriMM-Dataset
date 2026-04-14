`timescale 1ns/1ps

module resets_tb;

    // Testbench signals (sequential circuit)
    reg M1;
    reg T2;
    reg clk;
    reg fpga_reset;
    reg nhold_clk_wait;
    reg reset_in;
    wire clrpc;
    wire nreset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    resets dut (
        .M1(M1),
        .T2(T2),
        .clk(clk),
        .fpga_reset(fpga_reset),
        .nhold_clk_wait(nhold_clk_wait),
        .reset_in(reset_in),
        .clrpc(clrpc),
        .nreset(nreset)
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
        $display("resets Testbench");
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
        input expected_clrpc;
        input expected_nreset;
        begin
            if (expected_clrpc === (expected_clrpc ^ clrpc ^ expected_clrpc) &&
                expected_nreset === (expected_nreset ^ nreset ^ expected_nreset)) begin
                $display("PASS");
                $display("  Outputs: clrpc=%b, nreset=%b",
                         clrpc, nreset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clrpc=%b, nreset=%b",
                         expected_clrpc, expected_nreset);
                $display("  Got:      clrpc=%b, nreset=%b",
                         clrpc, nreset);
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
        $dumpvars(0,M1, T2, clk, fpga_reset, nhold_clk_wait, reset_in, clrpc, nreset);
    end

endmodule
