`timescale 1ns/1ps

module linear_voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] actual_voltage;
    reg [3:0] desired_voltage;
    wire control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_voltage_regulator dut (
        .actual_voltage(actual_voltage),
        .desired_voltage(desired_voltage),
        .control_signal(control_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Actual < Desired (5 < 10)", test_num);
            actual_voltage = 4'd5;
            desired_voltage = 4'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Actual > Desired (12 > 8)", test_num);
            actual_voltage = 4'd12;
            desired_voltage = 4'd8;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Actual == Desired (7 == 7)", test_num);
            actual_voltage = 4'd7;
            desired_voltage = 4'd7;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower Boundary Condition (0 == 0)", test_num);
            actual_voltage = 4'd0;
            desired_voltage = 4'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower Boundary Comparison (0 < 1)", test_num);
            actual_voltage = 4'd0;
            desired_voltage = 4'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper Boundary Condition (15 == 15)", test_num);
            actual_voltage = 4'd15;
            desired_voltage = 4'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper Boundary Comparison (14 < 15)", test_num);
            actual_voltage = 4'd14;
            desired_voltage = 4'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Scale High to Low (15 > 0)", test_num);
            actual_voltage = 4'd15;
            desired_voltage = 4'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Scale Low to High (0 < 15)", test_num);
            actual_voltage = 4'd0;
            desired_voltage = 4'd15;
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
        $display("linear_voltage_regulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_control_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%b",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%b",
                         expected_control_signal);
                $display("  Got:      control_signal=%b",
                         control_signal);
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
