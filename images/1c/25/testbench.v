`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (combinational circuit)
    reg power_ctrl;
    reg status;
    wire power_gated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .power_ctrl(power_ctrl),
        .status(status),
        .power_gated(power_gated)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: power_ctrl=0, status=0");
            power_ctrl = 0;
            status = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: power_ctrl=0, status=1");
            power_ctrl = 0;
            status = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: power_ctrl=1, status=0 (Gating condition)");
            power_ctrl = 1;
            status = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: power_ctrl=1, status=1");
            power_ctrl = 1;
            status = 1;
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
        $display("power_gating_controller Testbench");
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
        input expected_power_gated;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_gated === (expected_power_gated ^ power_gated ^ expected_power_gated)) begin
                $display("PASS");
                $display("  Outputs: power_gated=%b",
                         power_gated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_gated=%b",
                         expected_power_gated);
                $display("  Got:      power_gated=%b",
                         power_gated);
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
