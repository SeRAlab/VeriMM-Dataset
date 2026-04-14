`timescale 1ns/1ps

module SQM_PWM_LOG_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] din;
    wire [7:0] rep0;
    wire [7:0] rep1;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SQM_PWM_LOG dut (
        .din(din),
        .rep0(rep0),
        .rep1(rep1),
        .zero(zero)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SQM_PWM_LOG Testbench");
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
        input [7:0] expected_rep0;
        input [7:0] expected_rep1;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rep0 === (expected_rep0 ^ rep0 ^ expected_rep0) &&
                expected_rep1 === (expected_rep1 ^ rep1 ^ expected_rep1) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: rep0=%h, rep1=%h, zero=%b",
                         rep0, rep1, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rep0=%h, rep1=%h, zero=%b",
                         expected_rep0, expected_rep1, expected_zero);
                $display("  Got:      rep0=%h, rep1=%h, zero=%b",
                         rep0, rep1, zero);
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
