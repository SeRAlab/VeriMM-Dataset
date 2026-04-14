`timescale 1ns/1ps

module PP_LOW_tb;

    // Testbench signals (combinational circuit)
    reg INA;
    reg INB;
    reg ONENEG;
    reg ONEPOS;
    reg TWONEG;
    wire PPBIT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PP_LOW dut (
        .INA(INA),
        .INB(INB),
        .ONENEG(ONENEG),
        .ONEPOS(ONEPOS),
        .TWONEG(TWONEG),
        .PPBIT(PPBIT)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PP_LOW Testbench");
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
        input expected_PPBIT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PPBIT === (expected_PPBIT ^ PPBIT ^ expected_PPBIT)) begin
                $display("PASS");
                $display("  Outputs: PPBIT=%b",
                         PPBIT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PPBIT=%b",
                         expected_PPBIT);
                $display("  Got:      PPBIT=%b",
                         PPBIT);
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
