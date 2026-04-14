`timescale 1ns/1ps

module debouncer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg switch_in;
    wire switch_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    debouncer dut (
        .clk(clk),
        .reset(reset),
        .switch_in(switch_in),
        .switch_out(switch_out)
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
        $display("debouncer Testbench");
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
        input expected_switch_out;
        begin
            if (expected_switch_out === (expected_switch_out ^ switch_out ^ expected_switch_out)) begin
                $display("PASS");
                $display("  Outputs: switch_out=%b",
                         switch_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: switch_out=%b",
                         expected_switch_out);
                $display("  Got:      switch_out=%b",
                         switch_out);
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
        $dumpvars(0,clk, reset, switch_in, switch_out);
    end

endmodule
