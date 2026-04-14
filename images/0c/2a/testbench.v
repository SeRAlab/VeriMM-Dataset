`timescale 1ns/1ps

module linear_voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] feedback_voltage;
    reg [7:0] reference_voltage;
    wire control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_voltage_regulator dut (
        .feedback_voltage(feedback_voltage),
        .reference_voltage(reference_voltage),
        .control_signal(control_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Feedback less than Reference (Normal Operation)", test_num);
            feedback_voltage = 8'd50;
            reference_voltage = 8'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Feedback greater than Reference (Overvoltage)", test_num);
            feedback_voltage = 8'd150;
            reference_voltage = 8'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Feedback equal to Reference (Target Reached)", test_num);
            feedback_voltage = 8'd100;
            reference_voltage = 8'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Feedback, Maximum Reference", test_num);
            feedback_voltage = 8'd0;
            reference_voltage = 8'd255;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Feedback, Minimum Reference", test_num);
            feedback_voltage = 8'd255;
            reference_voltage = 8'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Voltage Boundary", test_num);
            feedback_voltage = 8'd0;
            reference_voltage = 8'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Voltage Boundary", test_num);
            feedback_voltage = 8'hFF;
            reference_voltage = 8'hFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Off-by-one (Feedback slightly lower)", test_num);
            feedback_voltage = 8'd127;
            reference_voltage = 8'd128;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Off-by-one (Feedback slightly higher)", test_num);
            feedback_voltage = 8'd129;
            reference_voltage = 8'd128;
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
