`timescale 1ns/1ps

module debounce_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg noisy_button;
    reg rst_n;
    wire clean_button;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    debounce dut (
        .clk(clk),
        .noisy_button(noisy_button),
        .rst_n(rst_n),
        .clean_button(clean_button)
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
        $display("debounce Testbench");
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
        input expected_clean_button;
        begin
            if (expected_clean_button === (expected_clean_button ^ clean_button ^ expected_clean_button)) begin
                $display("PASS");
                $display("  Outputs: clean_button=%b",
                         clean_button);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clean_button=%b",
                         expected_clean_button);
                $display("  Got:      clean_button=%b",
                         clean_button);
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
        $dumpvars(0,clk, noisy_button, rst_n, clean_button);
    end

endmodule
