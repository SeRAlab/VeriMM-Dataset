`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] x;
    reg [4:0] y;
    wire eq;
    wire ge;
    wire gt;
    wire le;
    wire lt;
    wire ne;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .eq(eq),
        .ge(ge),
        .gt(gt),
        .le(le),
        .lt(lt),
        .ne(ne)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: x=0, y=0 (Equal)", test_num);
            x = 5'd0;
            y = 5'd0;

            #1;


            check_outputs(1, 1, 0, 1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: x=31, y=31 (Equal)", test_num);
            x = 5'd31;
            y = 5'd31;

            #1;


            check_outputs(1, 1, 0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: x=5, y=25 (Less Than)", test_num);
            x = 5'd5;
            y = 5'd25;

            #1;


            check_outputs(0, 0, 0, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: x=28, y=2 (Greater Than)", test_num);
            x = 5'd28;
            y = 5'd2;

            #1;


            check_outputs(0, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: x=15, y=16 (Less Than)", test_num);
            x = 5'd15;
            y = 5'd16;

            #1;


            check_outputs(0, 0, 0, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: x=16, y=15 (Greater Than)", test_num);
            x = 5'd16;
            y = 5'd15;

            #1;


            check_outputs(0, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: x=0, y=31 (Min vs Max)", test_num);
            x = 5'd0;
            y = 5'd31;

            #1;


            check_outputs(0, 0, 0, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: x=31, y=0 (Max vs Min)", test_num);
            x = 5'd31;
            y = 5'd0;

            #1;


            check_outputs(0, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: x=10, y=10 (Equal)", test_num);
            x = 5'd10;
            y = 5'd10;

            #1;


            check_outputs(1, 1, 0, 1, 0, 0);
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
        input expected_eq;
        input expected_ge;
        input expected_gt;
        input expected_le;
        input expected_lt;
        input expected_ne;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_ge === (expected_ge ^ ge ^ expected_ge) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt) &&
                expected_le === (expected_le ^ le ^ expected_le) &&
                expected_lt === (expected_lt ^ lt ^ expected_lt) &&
                expected_ne === (expected_ne ^ ne ^ expected_ne)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, ge=%b, gt=%b, le=%b, lt=%b, ne=%b",
                         eq, ge, gt, le, lt, ne);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, ge=%b, gt=%b, le=%b, lt=%b, ne=%b",
                         expected_eq, expected_ge, expected_gt, expected_le, expected_lt, expected_ne);
                $display("  Got:      eq=%b, ge=%b, gt=%b, le=%b, lt=%b, ne=%b",
                         eq, ge, gt, le, lt, ne);
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
