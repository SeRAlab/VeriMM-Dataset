`timescale 1ns/1ps

module SRAM_tb;

    // Testbench signals (combinational circuit)
    reg CE;
    reg [3:0] MAR_IN;
    wire [8:0] SRAM_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM dut (
        .CE(CE),
        .MAR_IN(MAR_IN),
        .SRAM_OUT(SRAM_OUT)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM Testbench");
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
        input [8:0] expected_SRAM_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SRAM_OUT === (expected_SRAM_OUT ^ SRAM_OUT ^ expected_SRAM_OUT)) begin
                $display("PASS");
                $display("  Outputs: SRAM_OUT=%h",
                         SRAM_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SRAM_OUT=%h",
                         expected_SRAM_OUT);
                $display("  Got:      SRAM_OUT=%h",
                         SRAM_OUT);
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

endmodule
