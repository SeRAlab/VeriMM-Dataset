`timescale 1ns/1ps

module EdgeDetector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_signal;
    reg rst_n;
    wire out_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    EdgeDetector dut (
        .clk(clk),
        .in_signal(in_signal),
        .rst_n(rst_n),
        .out_pulse(out_pulse)
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
        $display("EdgeDetector Testbench");
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
        input expected_out_pulse;
        begin
            if (expected_out_pulse === (expected_out_pulse ^ out_pulse ^ expected_out_pulse)) begin
                $display("PASS");
                $display("  Outputs: out_pulse=%b",
                         out_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_pulse=%b",
                         expected_out_pulse);
                $display("  Got:      out_pulse=%b",
                         out_pulse);
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
        $dumpvars(0,clk, in_signal, rst_n, out_pulse);
    end

endmodule
