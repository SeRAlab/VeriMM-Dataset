`timescale 1ns/1ps

module rconst_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] i;
    wire [63:0] rc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rconst dut (
        .i(i),
        .rc(rc)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rconst Testbench");
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
        input [63:0] expected_rc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rc === (expected_rc ^ rc ^ expected_rc)) begin
                $display("PASS");
                $display("  Outputs: rc=%h",
                         rc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rc=%h",
                         expected_rc);
                $display("  Got:      rc=%h",
                         rc);
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
