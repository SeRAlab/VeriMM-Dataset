`timescale 1ns/1ps

module OREG_tb;

    // Testbench signals (sequential circuit)
    reg LO;
    reg [8:0] O_IN;
    reg clk;
    wire [8:0] O_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    OREG dut (
        .LO(LO),
        .O_IN(O_IN),
        .clk(clk),
        .O_OUT(O_OUT)
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
        $display("OREG Testbench");
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
        input [8:0] expected_O_OUT;
        begin
            if (expected_O_OUT === (expected_O_OUT ^ O_OUT ^ expected_O_OUT)) begin
                $display("PASS");
                $display("  Outputs: O_OUT=%h",
                         O_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O_OUT=%h",
                         expected_O_OUT);
                $display("  Got:      O_OUT=%h",
                         O_OUT);
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
        $dumpvars(0,LO, O_IN, clk, O_OUT);
    end

endmodule
