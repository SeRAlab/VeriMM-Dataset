`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] temp_input;
    wire [4:0] temp_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .temp_input(temp_input),
        .temp_output(temp_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Minimum Input", test_num);
        temp_input = 5'd0;
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Typical Mid-range Input", test_num);
        temp_input = 5'd15;
        #1;

        check_outputs(5'd18);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Boundary Input (Exactly Max Output)", test_num);
        temp_input = 5'd28;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Saturation Input (Expected 32 -> 31)", test_num);
        temp_input = 5'd29;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Maximum Input Saturation (Expected 34 -> 31)", test_num);
        temp_input = 5'd31;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Random Calibration Point", test_num);
        temp_input = 5'd10;
        #1;

        check_outputs(5'd13);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("thermal_sensor_calibration Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [4:0] expected_temp_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_temp_output === (expected_temp_output ^ temp_output ^ expected_temp_output)) begin
                $display("PASS");
                $display("  Outputs: temp_output=%h",
                         temp_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_output=%h",
                         expected_temp_output);
                $display("  Got:      temp_output=%h",
                         temp_output);
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
