`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (combinational circuit)
    reg control_signal;
    reg power_state;
    wire power_gated_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .control_signal(control_signal),
        .power_state(power_state),
        .power_gated_signal(power_gated_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: control_signal=0, power_state=0 -> Expected: 0", test_num);
            control_signal = 1'b0;
            power_state = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: control_signal=0, power_state=1 -> Expected: 0", test_num);
            control_signal = 1'b0;
            power_state = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: control_signal=1, power_state=0 -> Expected: 1 (Activation condition)", test_num);
            control_signal = 1'b1;
            power_state = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: control_signal=1, power_state=1 -> Expected: 0", test_num);
            control_signal = 1'b1;
            power_state = 1'b1;
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
        input expected_power_gated_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_gated_signal === (expected_power_gated_signal ^ power_gated_signal ^ expected_power_gated_signal)) begin
                $display("PASS");
                $display("  Outputs: power_gated_signal=%b",
                         power_gated_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_gated_signal=%b",
                         expected_power_gated_signal);
                $display("  Got:      power_gated_signal=%b",
                         power_gated_signal);
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
