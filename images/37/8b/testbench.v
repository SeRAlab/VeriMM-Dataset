`timescale 1ns/1ps

module temperature_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] temperature;
    wire [2:0] temperature_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor dut (
        .temperature(temperature),
        .temperature_level(temperature_level)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 0 (Lower Bound Low)", test_num);
            temperature = 4'd0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 3 (Mid Low)", test_num);
            temperature = 4'd3;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 5 (Upper Bound Low)", test_num);
            temperature = 4'd5;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 6 (Lower Bound Moderate)", test_num);
            temperature = 4'd6;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 8 (Mid Moderate)", test_num);
            temperature = 4'd8;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 10 (Upper Bound Moderate)", test_num);
            temperature = 4'd10;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 11 (Lower Bound High)", test_num);
            temperature = 4'd11;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 13 (Mid High)", test_num);
            temperature = 4'd13;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature = 15 (Upper Bound High)", test_num);
            temperature = 4'd15;
            #1;

            check_outputs(3'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_sensor Testbench");
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
        input [2:0] expected_temperature_level;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_temperature_level === (expected_temperature_level ^ temperature_level ^ expected_temperature_level)) begin
                $display("PASS");
                $display("  Outputs: temperature_level=%h",
                         temperature_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temperature_level=%h",
                         expected_temperature_level);
                $display("  Got:      temperature_level=%h",
                         temperature_level);
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
