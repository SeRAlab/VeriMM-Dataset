`timescale 1ns/1ps

module power_gating_controller_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg power_gate_control;
    reg sensor_input;
    wire power_gate_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_controller dut (
        .enable(enable),
        .power_gate_control(power_gate_control),
        .sensor_input(sensor_input),
        .power_gate_signal(power_gate_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs LOW", test_num);
            enable = 1'b0;
            power_gate_control = 1'b0;
            sensor_input = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Only enable HIGH", test_num);
            enable = 1'b1;
            power_gate_control = 1'b0;
            sensor_input = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Only power_gate_control HIGH", test_num);
            enable = 1'b0;
            power_gate_control = 1'b1;
            sensor_input = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Only sensor_input HIGH", test_num);
            enable = 1'b0;
            power_gate_control = 1'b0;
            sensor_input = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: enable and power_gate_control HIGH, sensor_input LOW", test_num);
            enable = 1'b1;
            power_gate_control = 1'b1;
            sensor_input = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: enable and sensor_input HIGH, power_gate_control LOW", test_num);
            enable = 1'b1;
            power_gate_control = 1'b0;
            sensor_input = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: power_gate_control and sensor_input HIGH, enable LOW", test_num);
            enable = 1'b0;
            power_gate_control = 1'b1;
            sensor_input = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs HIGH (Conditions Met)", test_num);
            enable = 1'b1;
            power_gate_control = 1'b1;
            sensor_input = 1'b1;
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
        input expected_power_gate_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_gate_signal === (expected_power_gate_signal ^ power_gate_signal ^ expected_power_gate_signal)) begin
                $display("PASS");
                $display("  Outputs: power_gate_signal=%b",
                         power_gate_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_gate_signal=%b",
                         expected_power_gate_signal);
                $display("  Got:      power_gate_signal=%b",
                         power_gate_signal);
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
