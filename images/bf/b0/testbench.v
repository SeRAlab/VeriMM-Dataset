`timescale 1ns/1ps

module operator_C_tb;

    // Testbench signals (combinational circuit)
    reg G;
    reg G1;
    reg P;
    wire Go;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    operator_C dut (
        .G(G),
        .G1(G1),
        .P(P),
        .Go(Go)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("operator_C Testbench");
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
        input expected_Go;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Go === (expected_Go ^ Go ^ expected_Go)) begin
                $display("PASS");
                $display("  Outputs: Go=%b",
                         Go);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Go=%b",
                         expected_Go);
                $display("  Got:      Go=%b",
                         Go);
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
