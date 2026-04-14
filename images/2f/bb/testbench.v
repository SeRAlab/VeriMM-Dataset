`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] voltage_level;
    wire above_threshold;
    wire high_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .voltage_level(voltage_level),
        .above_threshold(above_threshold),
        .high_voltage(high_voltage)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Minimum voltage level (0)", test_num);
        voltage_level = 5'd0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Typical low voltage level (10)", test_num);
        voltage_level = 5'd10;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Voltage level just below threshold (19)", test_num);
        voltage_level = 5'd19;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Voltage level exactly at threshold (20)", test_num);
        voltage_level = 5'd20;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Voltage level just above threshold (21)", test_num);
        voltage_level = 5'd21;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Typical high voltage level (25)", test_num);
        voltage_level = 5'd25;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Maximum voltage level (31)", test_num);
        voltage_level = 5'd31;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_sensor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_above_threshold;
        input expected_high_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_above_threshold === (expected_above_threshold ^ above_threshold ^ expected_above_threshold) &&
                expected_high_voltage === (expected_high_voltage ^ high_voltage ^ expected_high_voltage)) begin
                $display("PASS");
                $display("  Outputs: above_threshold=%b, high_voltage=%b",
                         above_threshold, high_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: above_threshold=%b, high_voltage=%b",
                         expected_above_threshold, expected_high_voltage);
                $display("  Got:      above_threshold=%b, high_voltage=%b",
                         above_threshold, high_voltage);
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
