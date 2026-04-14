`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg power_enable;
    wire power_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .control(control),
        .power_enable(power_enable),
        .power_signal(power_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both signals low", test_num);
            power_enable = 0;
            control = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power enable low, Control high", test_num);
            power_enable = 0;
            control = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power enable high, Control low", test_num);
            power_enable = 1;
            control = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both signals high (Power On)", test_num);
            power_enable = 1;
            control = 1;
            #1;

            check_outputs(1'b1);
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
        input expected_power_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_signal === (expected_power_signal ^ power_signal ^ expected_power_signal)) begin
                $display("PASS");
                $display("  Outputs: power_signal=%b",
                         power_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_signal=%b",
                         expected_power_signal);
                $display("  Got:      power_signal=%b",
                         power_signal);
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
