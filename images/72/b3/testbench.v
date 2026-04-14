`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] phase_currents_0;
    reg [17:0] phase_currents_1;
    wire [17:0] alpha_current;
    wire [17:0] beta_current;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .phase_currents_0(phase_currents_0),
        .phase_currents_1(phase_currents_1),
        .alpha_current(alpha_current),
        .beta_current(beta_current)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs", test_num);
            phase_currents_0 = 18'sd0;
            phase_currents_1 = 18'sd0;
            #1;

            check_outputs(18'sd0, 18'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Positive Alpha", test_num);
            phase_currents_0 = 18'sd15000;
            phase_currents_1 = -18'sd7500;
            #1;

            check_outputs(18'sd15000, 18'sd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Positive Beta", test_num);
            phase_currents_0 = 18'sd0;
            phase_currents_1 = 18'sd8660;
            #1;

            check_outputs(18'sd0, 18'sd10000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Negative Alpha", test_num);
            phase_currents_0 = -18'sd20000;
            phase_currents_1 = 18'sd10000;
            #1;

            check_outputs(-18'sd20000, 18'sd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Negative Beta", test_num);
            phase_currents_0 = 18'sd0;
            phase_currents_1 = -18'sd8660;
            #1;

            check_outputs(18'sd0, -18'sd10000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Components", test_num);
            phase_currents_0 = 18'sd10000;
            phase_currents_1 = 18'sd0;
            #1;

            check_outputs(18'sd10000, 18'sd5773);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Positive Values", test_num);
            phase_currents_0 = 18'sd80000;
            phase_currents_1 = -18'sd40000;
            #1;

            check_outputs(18'sd80000, 18'sd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Beta Magnitude", test_num);
            phase_currents_0 = 18'sd40000;
            phase_currents_1 = 18'sd40000;
            #1;

            check_outputs(18'sd40000, 18'sd69282);
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
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [17:0] expected_alpha_current;
        input [17:0] expected_beta_current;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alpha_current === (expected_alpha_current ^ alpha_current ^ expected_alpha_current) &&
                expected_beta_current === (expected_beta_current ^ beta_current ^ expected_beta_current)) begin
                $display("PASS");
                $display("  Outputs: alpha_current=%h, beta_current=%h",
                         alpha_current, beta_current);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alpha_current=%h, beta_current=%h",
                         expected_alpha_current, expected_beta_current);
                $display("  Got:      alpha_current=%h, beta_current=%h",
                         alpha_current, beta_current);
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
