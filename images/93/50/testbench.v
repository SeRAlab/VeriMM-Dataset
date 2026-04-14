`timescale 1ns/1ps

module lfsr5_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    wire [4:0] LFSR_Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr5 dut (
        .CLK(CLK),
        .RST(RST),
        .LFSR_Out(LFSR_Out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
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
        $display("lfsr5 Testbench");
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
        input [4:0] expected_LFSR_Out;
        begin
            if (expected_LFSR_Out === (expected_LFSR_Out ^ LFSR_Out ^ expected_LFSR_Out)) begin
                $display("PASS");
                $display("  Outputs: LFSR_Out=%h",
                         LFSR_Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LFSR_Out=%h",
                         expected_LFSR_Out);
                $display("  Got:      LFSR_Out=%h",
                         LFSR_Out);
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
        $dumpvars(0,CLK, RST, LFSR_Out);
    end

endmodule
