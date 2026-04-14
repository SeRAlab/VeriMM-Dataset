`timescale 1ns/1ps

module comparator_1bit_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    wire Eq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_1bit dut (
        .A(A),
        .B(B),
        .Eq(Eq)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_1bit Testbench");
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
        input expected_Eq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Eq === (expected_Eq ^ Eq ^ expected_Eq)) begin
                $display("PASS");
                $display("  Outputs: Eq=%b",
                         Eq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Eq=%b",
                         expected_Eq);
                $display("  Got:      Eq=%b",
                         Eq);
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
