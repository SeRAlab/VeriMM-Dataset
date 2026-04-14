`timescale 1ns/1ps

module edge_detect_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clk;
    reg rst_n;
    wire down;
    wire rise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    edge_detect dut (
        .a(a),
        .clk(clk),
        .rst_n(rst_n),
        .down(down),
        .rise(rise)
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
        $display("edge_detect Testbench");
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
        input expected_down;
        input expected_rise;
        begin
            if (expected_down === (expected_down ^ down ^ expected_down) &&
                expected_rise === (expected_rise ^ rise ^ expected_rise)) begin
                $display("PASS");
                $display("  Outputs: down=%b, rise=%b",
                         down, rise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: down=%b, rise=%b",
                         expected_down, expected_rise);
                $display("  Got:      down=%b, rise=%b",
                         down, rise);
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
        $dumpvars(0,a, clk, rst_n, down, rise);
    end

endmodule
