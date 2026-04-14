`timescale 1ns/1ps

module hvsync_gen_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire h_sync;
    wire v_sync;
    wire [9:0] wcntX;
    wire [8:0] wcntY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hvsync_gen dut (
        .clk(clk),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .wcntX(wcntX),
        .wcntY(wcntY)
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
        $display("hvsync_gen Testbench");
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
        input expected_h_sync;
        input expected_v_sync;
        input [9:0] expected_wcntX;
        input [8:0] expected_wcntY;
        begin
            if (expected_h_sync === (expected_h_sync ^ h_sync ^ expected_h_sync) &&
                expected_v_sync === (expected_v_sync ^ v_sync ^ expected_v_sync) &&
                expected_wcntX === (expected_wcntX ^ wcntX ^ expected_wcntX) &&
                expected_wcntY === (expected_wcntY ^ wcntY ^ expected_wcntY)) begin
                $display("PASS");
                $display("  Outputs: h_sync=%b, v_sync=%b, wcntX=%h, wcntY=%h",
                         h_sync, v_sync, wcntX, wcntY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_sync=%b, v_sync=%b, wcntX=%h, wcntY=%h",
                         expected_h_sync, expected_v_sync, expected_wcntX, expected_wcntY);
                $display("  Got:      h_sync=%b, v_sync=%b, wcntX=%h, wcntY=%h",
                         h_sync, v_sync, wcntX, wcntY);
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
        $dumpvars(0,clk, h_sync, v_sync, wcntX, wcntY);
    end

endmodule
