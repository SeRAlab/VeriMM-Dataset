`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg GIN;
    reg PHI;
    wire GOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .GIN(GIN),
        .PHI(PHI),
        .GOUT(GOUT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: GIN=0, PHI=0 (GOUT should be 1)", test_num);
        GIN = 1'b0;
        PHI = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: GIN=1, PHI=0 (GOUT should be 0)", test_num);
        GIN = 1'b1;
        PHI = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: GIN=0, PHI=1 (GOUT should be 1)", test_num);
        GIN = 1'b0;
        PHI = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: GIN=1, PHI=1 (GOUT should be 0)", test_num);
        GIN = 1'b1;
        PHI = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
