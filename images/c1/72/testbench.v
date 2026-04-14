`timescale 1ns/1ps

module DECODER_tb;

    // Testbench signals (combinational circuit)
    reg INA;
    reg INB;
    reg INC;
    wire ONENEG;
    wire ONEPOS;
    wire TWONEG;
    wire TWOPOS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DECODER dut (
        .INA(INA),
        .INB(INB),
        .INC(INC),
        .ONENEG(ONENEG),
        .ONEPOS(ONEPOS),
        .TWONEG(TWONEG),
        .TWOPOS(TWOPOS)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DECODER Testbench");
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
        input expected_ONENEG;
        input expected_ONEPOS;
        input expected_TWONEG;
        input expected_TWOPOS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ONENEG === (expected_ONENEG ^ ONENEG ^ expected_ONENEG) &&
                expected_ONEPOS === (expected_ONEPOS ^ ONEPOS ^ expected_ONEPOS) &&
                expected_TWONEG === (expected_TWONEG ^ TWONEG ^ expected_TWONEG) &&
                expected_TWOPOS === (expected_TWOPOS ^ TWOPOS ^ expected_TWOPOS)) begin
                $display("PASS");
                $display("  Outputs: ONENEG=%b, ONEPOS=%b, TWONEG=%b, TWOPOS=%b",
                         ONENEG, ONEPOS, TWONEG, TWOPOS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ONENEG=%b, ONEPOS=%b, TWONEG=%b, TWOPOS=%b",
                         expected_ONENEG, expected_ONEPOS, expected_TWONEG, expected_TWOPOS);
                $display("  Got:      ONENEG=%b, ONEPOS=%b, TWONEG=%b, TWOPOS=%b",
                         ONENEG, ONEPOS, TWONEG, TWOPOS);
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
