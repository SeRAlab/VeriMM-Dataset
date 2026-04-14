`timescale 1ns/1ps

module rf_dist_cm3_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] a;
    reg clk;
    reg [31:0] d;
    reg [6:0] dpra;
    reg we;
    wire [31:0] dpo;
    wire [31:0] spo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rf_dist_cm3 dut (
        .a(a),
        .clk(clk),
        .d(d),
        .dpra(dpra),
        .we(we),
        .dpo(dpo),
        .spo(spo)
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
        $display("rf_dist_cm3 Testbench");
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
        input [31:0] expected_dpo;
        input [31:0] expected_spo;
        begin
            if (expected_dpo === (expected_dpo ^ dpo ^ expected_dpo) &&
                expected_spo === (expected_spo ^ spo ^ expected_spo)) begin
                $display("PASS");
                $display("  Outputs: dpo=%h, spo=%h",
                         dpo, spo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dpo=%h, spo=%h",
                         expected_dpo, expected_spo);
                $display("  Got:      dpo=%h, spo=%h",
                         dpo, spo);
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
        $dumpvars(0,a, clk, d, dpra, we, dpo, spo);
    end

endmodule
