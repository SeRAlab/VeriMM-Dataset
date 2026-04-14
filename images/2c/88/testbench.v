`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] temperature_in;
    wire [9:0] temperature_out;

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
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature below 100 (Input: 0)", test_num);
            temperature_in = 10'd0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature below 100 (Input: 50)", test_num);
            temperature_in = 10'd50;
            #1;

            check_outputs(10'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary below 100 (Input: 99)", test_num);
            temperature_in = 10'd99;
            #1;

            check_outputs(10'd99);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary exactly at 100 (Input: 100)", test_num);
            temperature_in = 10'd100;
            #1;

            check_outputs(10'd90);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary just above 100 (Input: 101)", test_num);
            temperature_in = 10'd101;
            #1;

            check_outputs(10'd91);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature above 100 (Input: 500)", test_num);
            temperature_in = 10'd500;
            #1;

            check_outputs(10'd490);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum input value (Input: 1023)", test_num);
            temperature_in = 10'd1023;
            #1;

            check_outputs(10'd1013);
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
        input [9:0] expected_temperature_out;
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
