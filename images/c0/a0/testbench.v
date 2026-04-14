`timescale 1ns/1ps

module rconst2in1_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] i;
    wire [63:0] rc1;
    wire [63:0] rc2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rconst2in1 dut (
        .i(i),
        .rc1(rc1),
        .rc2(rc2)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rconst2in1 Testbench");
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
        input [63:0] expected_rc1;
        input [63:0] expected_rc2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rc1 === (expected_rc1 ^ rc1 ^ expected_rc1) &&
                expected_rc2 === (expected_rc2 ^ rc2 ^ expected_rc2)) begin
                $display("PASS");
                $display("  Outputs: rc1=%h, rc2=%h",
                         rc1, rc2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rc1=%h, rc2=%h",
                         expected_rc1, expected_rc2);
                $display("  Got:      rc1=%h, rc2=%h",
                         rc1, rc2);
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
