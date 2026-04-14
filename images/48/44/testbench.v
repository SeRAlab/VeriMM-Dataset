`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg north;
    reg request;
    reg west;
    wire east;
    wire grant;
    wire south;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .north(north),
        .request(request),
        .west(west),
        .east(east),
        .grant(grant),
        .south(south)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All inputs inactive", test_num);
            north = 0;
            west = 0;
            request = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: North requests, Request low", test_num);
            north = 1;
            west = 0;
            request = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: North requests, Request high -> South active", test_num);
            north = 1;
            west = 0;
            request = 1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: West requests, Request high -> East active", test_num);
            north = 0;
            west = 1;
            request = 1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: North and West request -> Grant active, others inactive", test_num);
            north = 1;
            west = 1;
            request = 1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: North and West request, Request low", test_num);
            north = 1;
            west = 1;
            request = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Request active, no sources", test_num);
            north = 0;
            west = 0;
            request = 1;
            #1;

            check_outputs(0, 0, 0);
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
        input expected_east;
        input expected_grant;
        input expected_south;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_east === (expected_east ^ east ^ expected_east) &&
                expected_grant === (expected_grant ^ grant ^ expected_grant) &&
                expected_south === (expected_south ^ south ^ expected_south)) begin
                $display("PASS");
                $display("  Outputs: east=%b, grant=%b, south=%b",
                         east, grant, south);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: east=%b, grant=%b, south=%b",
                         expected_east, expected_grant, expected_south);
                $display("  Got:      east=%b, grant=%b, south=%b",
                         east, grant, south);
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
