`timescale 1ns/1ps

module NANO_PROG_COUNTER_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] MCR_IN;
    wire [5:0] NANO_PRE_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NANO_PROG_COUNTER dut (
        .MCR_IN(MCR_IN),
        .NANO_PRE_OUT(NANO_PRE_OUT)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NANO_PROG_COUNTER Testbench");
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
        input [5:0] expected_NANO_PRE_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_NANO_PRE_OUT === (expected_NANO_PRE_OUT ^ NANO_PRE_OUT ^ expected_NANO_PRE_OUT)) begin
                $display("PASS");
                $display("  Outputs: NANO_PRE_OUT=%h",
                         NANO_PRE_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NANO_PRE_OUT=%h",
                         expected_NANO_PRE_OUT);
                $display("  Got:      NANO_PRE_OUT=%h",
                         NANO_PRE_OUT);
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
