`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg fan_on;
    reg mode;
    reg too_cold;
    reg too_hot;
    wire aircon;
    wire fan;
    wire heater;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fan_on(fan_on),
        .mode(mode),
        .too_cold(too_cold),
        .too_hot(too_hot),
        .aircon(aircon),
        .fan(fan),
        .heater(heater)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: All inputs idle", test_num);
        too_cold = 0; too_hot = 0; mode = 0; fan_on = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Heating mode (on), temperature fine", test_num);
        too_cold = 0; too_hot = 0; mode = 1; fan_on = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Heating mode (on), temperature too cold", test_num);
        too_cold = 1; too_hot = 0; mode = 1; fan_on = 0;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Cooling mode (off), temperature fine", test_num);
        too_cold = 0; too_hot = 0; mode = 0; fan_on = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Cooling mode (off), temperature too hot", test_num);
        too_cold = 0; too_hot = 1; mode = 0; fan_on = 0;
        #1;

        check_outputs(1, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Manual fan override active", test_num);
        too_cold = 0; too_hot = 0; mode = 0; fan_on = 1;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Heating mode, but temperature too hot", test_num);
        too_cold = 0; too_hot = 1; mode = 1; fan_on = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Cooling mode, but temperature too cold", test_num);
        too_cold = 1; too_hot = 0; mode = 0; fan_on = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: Heating mode active with manual fan", test_num);
        too_cold = 1; too_hot = 0; mode = 1; fan_on = 1;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %0d: Cooling mode active with manual fan", test_num);
        too_cold = 0; too_hot = 1; mode = 0; fan_on = 1;
        #1;

        check_outputs(1, 1, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        testcase010();
        
        
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
        input expected_aircon;
        input expected_fan;
        input expected_heater;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aircon === (expected_aircon ^ aircon ^ expected_aircon) &&
                expected_fan === (expected_fan ^ fan ^ expected_fan) &&
                expected_heater === (expected_heater ^ heater ^ expected_heater)) begin
                $display("PASS");
                $display("  Outputs: aircon=%b, fan=%b, heater=%b",
                         aircon, fan, heater);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aircon=%b, fan=%b, heater=%b",
                         expected_aircon, expected_fan, expected_heater);
                $display("  Got:      aircon=%b, fan=%b, heater=%b",
                         aircon, fan, heater);
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
