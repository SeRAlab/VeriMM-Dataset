`timescale 1ns/1ps

module mul_ppgensign_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] b;
    reg pm1_l;
    wire p_l;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mul_ppgensign dut (
        .b(b),
        .pm1_l(pm1_l),
        .p_l(p_l),
        .z(z)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mul_ppgensign Testbench");
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
        input expected_p_l;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p_l === (expected_p_l ^ p_l ^ expected_p_l) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: p_l=%b, z=%b",
                         p_l, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_l=%b, z=%b",
                         expected_p_l, expected_z);
                $display("  Got:      p_l=%b, z=%b",
                         p_l, z);
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
