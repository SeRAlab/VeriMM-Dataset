`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg x;
    reg [3:0] y;
    wire Y0;
    wire Y2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .Y0(Y0),
        .Y2(Y2)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Current State N (y=0001), Input x=0. Expect Next State P (Y2=1, Y0=0)", test_num);
        y = 4'b0001;
        x = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Current State N (y=0001), Input x=1. Expect Next State O (Y2=0, Y0=0)", test_num);
        y = 4'b0001;
        x = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Current State O (y=0010), Input x=0. Expect Next State N (Y2=0, Y0=1)", test_num);
        y = 4'b0010;
        x = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Current State O (y=0010), Input x=1. Expect Next State Q (Y2=0, Y0=0)", test_num);
        y = 4'b0010;
        x = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Current State P (y=0100), Input x=0. Expect Next State O (Y2=0, Y0=0)", test_num);
        y = 4'b0100;
        x = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Current State P (y=0100), Input x=1. Expect Next State Q (Y2=0, Y0=0)", test_num);
        y = 4'b0100;
        x = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Current State Q (y=1000), Input x=0. Expect Next State N (Y2=0, Y0=1)", test_num);
        y = 4'b1000;
        x = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Current State Q (y=1000), Input x=1. Expect Next State P (Y2=1, Y0=0)", test_num);
        y = 4'b1000;
        x = 1'b1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Invalid State (y=0000), Input x=0. Expect Y2=0, Y0=0", test_num);
        y = 4'b0000;
        x = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_Y0;
        input expected_Y2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y0 === (expected_Y0 ^ Y0 ^ expected_Y0) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2)) begin
                $display("PASS");
                $display("  Outputs: Y0=%b, Y2=%b",
                         Y0, Y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y0=%b, Y2=%b",
                         expected_Y0, expected_Y2);
                $display("  Got:      Y0=%b, Y2=%b",
                         Y0, Y2);
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
