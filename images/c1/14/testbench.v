`timescale 1ns/1ps

module booth_radix4_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] codes;
    wire double;
    wire negation;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    booth_radix4 dut (
        .codes(codes),
        .double(double),
        .negation(negation),
        .zero(zero)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("booth_radix4 Testbench");
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
        input expected_double;
        input expected_negation;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_double === (expected_double ^ double ^ expected_double) &&
                expected_negation === (expected_negation ^ negation ^ expected_negation) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: double=%b, negation=%b, zero=%b",
                         double, negation, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: double=%b, negation=%b, zero=%b",
                         expected_double, expected_negation, expected_zero);
                $display("  Got:      double=%b, negation=%b, zero=%b",
                         double, negation, zero);
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
