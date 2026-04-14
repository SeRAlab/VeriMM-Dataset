`timescale 1ns/1ps

module dbg_sync_clk1_clk2_tb;

    // Testbench signals (sequential circuit)
    reg clk1;
    reg clk2;
    reg reset1;
    reg reset2;
    reg set2;
    wire sync_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dbg_sync_clk1_clk2 dut (
        .clk1(clk1),
        .clk2(clk2),
        .reset1(reset1),
        .reset2(reset2),
        .set2(set2),
        .sync_out(sync_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk1 = 0;
        forever #5 clk1 = ~clk1;
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
        $display("dbg_sync_clk1_clk2 Testbench");
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
        input expected_sync_out;
        begin
            if (expected_sync_out === (expected_sync_out ^ sync_out ^ expected_sync_out)) begin
                $display("PASS");
                $display("  Outputs: sync_out=%b",
                         sync_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sync_out=%b",
                         expected_sync_out);
                $display("  Got:      sync_out=%b",
                         sync_out);
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
        $dumpvars(0,clk1, clk2, reset1, reset2, set2, sync_out);
    end

endmodule
