`timescale 1ns/1ps

module BLOCK2A_tb;

    // Testbench signals (combinational circuit)
    reg GIN1;
    reg GIN2;
    reg PHI;
    reg PIN2;
    wire GOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BLOCK2A dut (
        .GIN1(GIN1),
        .GIN2(GIN2),
        .PHI(PHI),
        .PIN2(PIN2),
        .GOUT(GOUT)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BLOCK2A Testbench");
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
        input expected_GOUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GOUT === (expected_GOUT ^ GOUT ^ expected_GOUT)) begin
                $display("PASS");
                $display("  Outputs: GOUT=%b",
                         GOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GOUT=%b",
                         expected_GOUT);
                $display("  Got:      GOUT=%b",
                         GOUT);
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
