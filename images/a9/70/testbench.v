`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg arrived;
    reg cpu_overheated;
    reg gas_tank_empty;
    wire keep_driving;
    wire shut_off_computer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arrived(arrived),
        .cpu_overheated(cpu_overheated),
        .gas_tank_empty(gas_tank_empty),
        .keep_driving(keep_driving),
        .shut_off_computer(shut_off_computer)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Driving scenario (Not arrived, has fuel, no overheat)", test_num);
            cpu_overheated = 0;
            arrived = 0;
            gas_tank_empty = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: CPU Overheat while driving", test_num);
            cpu_overheated = 1;
            arrived = 0;
            gas_tank_empty = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Arrived at destination", test_num);
            cpu_overheated = 0;
            arrived = 1;
            gas_tank_empty = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Gas tank empty before arrival", test_num);
            cpu_overheated = 0;
            arrived = 0;
            gas_tank_empty = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Arrived and Overheated", test_num);
            cpu_overheated = 1;
            arrived = 1;
            gas_tank_empty = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Out of gas and Overheated", test_num);
            cpu_overheated = 1;
            arrived = 0;
            gas_tank_empty = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: All inputs High (Arrived, Empty Tank, Overheated)", test_num);
            cpu_overheated = 1;
            arrived = 1;
            gas_tank_empty = 1;
            #1;

            check_outputs(0, 1);
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
        input expected_keep_driving;
        input expected_shut_off_computer;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_keep_driving === (expected_keep_driving ^ keep_driving ^ expected_keep_driving) &&
                expected_shut_off_computer === (expected_shut_off_computer ^ shut_off_computer ^ expected_shut_off_computer)) begin
                $display("PASS");
                $display("  Outputs: keep_driving=%b, shut_off_computer=%b",
                         keep_driving, shut_off_computer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keep_driving=%b, shut_off_computer=%b",
                         expected_keep_driving, expected_shut_off_computer);
                $display("  Got:      keep_driving=%b, shut_off_computer=%b",
                         keep_driving, shut_off_computer);
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
