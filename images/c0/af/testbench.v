`timescale 1ns/1ps

module bitsplit_tb;

    // Testbench signals (sequential circuit)
    reg bit1_i;
    reg bit2_i;
    reg clk;
    reg run_i;
    reg swap_i;
    wire largebit_o;
    wire run_o;
    wire smallbit_o;
    wire swap_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitsplit dut (
        .bit1_i(bit1_i),
        .bit2_i(bit2_i),
        .clk(clk),
        .run_i(run_i),
        .swap_i(swap_i),
        .largebit_o(largebit_o),
        .run_o(run_o),
        .smallbit_o(smallbit_o),
        .swap_o(swap_o)
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
        $display("bitsplit Testbench");
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
        input expected_largebit_o;
        input expected_run_o;
        input expected_smallbit_o;
        input expected_swap_o;
        begin
            if (expected_largebit_o === (expected_largebit_o ^ largebit_o ^ expected_largebit_o) &&
                expected_run_o === (expected_run_o ^ run_o ^ expected_run_o) &&
                expected_smallbit_o === (expected_smallbit_o ^ smallbit_o ^ expected_smallbit_o) &&
                expected_swap_o === (expected_swap_o ^ swap_o ^ expected_swap_o)) begin
                $display("PASS");
                $display("  Outputs: largebit_o=%b, run_o=%b, smallbit_o=%b, swap_o=%b",
                         largebit_o, run_o, smallbit_o, swap_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: largebit_o=%b, run_o=%b, smallbit_o=%b, swap_o=%b",
                         expected_largebit_o, expected_run_o, expected_smallbit_o, expected_swap_o);
                $display("  Got:      largebit_o=%b, run_o=%b, smallbit_o=%b, swap_o=%b",
                         largebit_o, run_o, smallbit_o, swap_o);
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
        $dumpvars(0,bit1_i, bit2_i, clk, run_i, swap_i, largebit_o, run_o, smallbit_o, swap_o);
    end

endmodule
