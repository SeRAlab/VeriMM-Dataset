`timescale 1ns/1ps

module square_wave_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire wave;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    square_wave_generator dut (
        .clk(clk),
        .rst_n(rst_n),
        .wave(wave)
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
        $display("square_wave_generator Testbench");
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
        input expected_wave;
        begin
            if (expected_wave === (expected_wave ^ wave ^ expected_wave)) begin
                $display("PASS");
                $display("  Outputs: wave=%b",
                         wave);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wave=%b",
                         expected_wave);
                $display("  Got:      wave=%b",
                         wave);
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
        $dumpvars(0,clk, rst_n, wave);
    end

endmodule
