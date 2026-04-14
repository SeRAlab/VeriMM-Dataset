`timescale 1ns/1ps

module comparator_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire A_equal;
    wire A_greater;
    wire A_less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_4bit dut (
        .A(A),
        .B(B),
        .A_equal(A_equal),
        .A_greater(A_greater),
        .A_less(A_less)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_4bit Testbench");
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
        input expected_A_equal;
        input expected_A_greater;
        input expected_A_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_equal === (expected_A_equal ^ A_equal ^ expected_A_equal) &&
                expected_A_greater === (expected_A_greater ^ A_greater ^ expected_A_greater) &&
                expected_A_less === (expected_A_less ^ A_less ^ expected_A_less)) begin
                $display("PASS");
                $display("  Outputs: A_equal=%b, A_greater=%b, A_less=%b",
                         A_equal, A_greater, A_less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_equal=%b, A_greater=%b, A_less=%b",
                         expected_A_equal, expected_A_greater, expected_A_less);
                $display("  Got:      A_equal=%b, A_greater=%b, A_less=%b",
                         A_equal, A_greater, A_less);
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
