`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg C0;
    reg C1;
    reg I0;
    wire y0;
    wire y1;
    wire y2;
    wire y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C0(C0),
        .C1(C1),
        .I0(I0),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select y0 (C1=0, C0=0), Input I0=0", test_num);
            C1 = 0; C0 = 0; I0 = 0;
            #3;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select y0 (C1=0, C0=0), Input I0=1", test_num);
            C1 = 0; C0 = 0; I0 = 1;
            #3;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select y1 (C1=0, C0=1), Input I0=0", test_num);
            C1 = 0; C0 = 1; I0 = 0;
            #3;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select y1 (C1=0, C0=1), Input I0=1", test_num);
            C1 = 0; C0 = 1; I0 = 1;
            #3;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select y2 (C1=1, C0=0), Input I0=0", test_num);
            C1 = 1; C0 = 0; I0 = 0;
            #3;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select y2 (C1=1, C0=0), Input I0=1", test_num);
            C1 = 1; C0 = 0; I0 = 1;
            #3;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select y3 (C1=1, C0=1), Input I0=0", test_num);
            C1 = 1; C0 = 1; I0 = 0;
            #3;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select y3 (C1=1, C0=1), Input I0=1", test_num);
            C1 = 1; C0 = 1; I0 = 1;
            #3;
            #1;

            check_outputs(0, 0, 0, 1);
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
        input expected_y0;
        input expected_y1;
        input expected_y2;
        input expected_y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: y0=%b, y1=%b, y2=%b, y3=%b",
                         y0, y1, y2, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%b, y1=%b, y2=%b, y3=%b",
                         expected_y0, expected_y1, expected_y2, expected_y3);
                $display("  Got:      y0=%b, y1=%b, y2=%b, y3=%b",
                         y0, y1, y2, y3);
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
