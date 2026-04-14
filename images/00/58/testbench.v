`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] temperature_in;
    wire [7:0] temperature_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .temperature_in(temperature_in),
        .temperature_out(temperature_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Minimum boundary", test_num);
        temperature_in = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Small value", test_num);
        temperature_in = 8'd10;
        #1;

        check_outputs(8'd12);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Multiple of 5", test_num);
        temperature_in = 8'd25;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Mid-range value", test_num);
        temperature_in = 8'd50;
        #1;

        check_outputs(8'd60);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Standard range", test_num);
        temperature_in = 8'd100;
        #1;

        check_outputs(8'd120);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Large value", test_num);
        temperature_in = 8'd150;
        #1;

        check_outputs(8'd180);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: High value", test_num);
        temperature_in = 8'd200;
        #1;

        check_outputs(8'd240);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Near overflow boundary", test_num);
        temperature_in = 8'd210;
        #1;

        check_outputs(8'd252);
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
        input [7:0] expected_temperature_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_temperature_out === (expected_temperature_out ^ temperature_out ^ expected_temperature_out)) begin
                $display("PASS");
                $display("  Outputs: temperature_out=%h",
                         temperature_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temperature_out=%h",
                         expected_temperature_out);
                $display("  Got:      temperature_out=%h",
                         temperature_out);
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
