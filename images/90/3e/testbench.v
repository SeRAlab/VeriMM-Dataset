`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg f;
    reg [2:0] x;
    wire X0;
    wire X1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .f(f),
        .x(x),
        .X0(X0),
        .X1(X1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: State X (001), f=0 -> Expect Next State Z (X0=0, X1=0)", test_num);
            x = 3'b001;
            f = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State X (001), f=1 -> Expect Next State Y (X0=0, X1=1)", test_num);
            x = 3'b001;
            f = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State Y (010), f=0 -> Expect Next State X (X0=1, X1=0)", test_num);
            x = 3'b010;
            f = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State Y (010), f=1 -> Expect Next State Z (X0=0, X1=0)", test_num);
            x = 3'b010;
            f = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: State Z (100), f=0 -> Expect Next State Y (X0=0, X1=1)", test_num);
            x = 3'b100;
            f = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State Z (100), f=1 -> Expect Next State X (X0=1, X1=0)", test_num);
            x = 3'b100;
            f = 1;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_X0;
        input expected_X1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X0 === (expected_X0 ^ X0 ^ expected_X0) &&
                expected_X1 === (expected_X1 ^ X1 ^ expected_X1)) begin
                $display("PASS");
                $display("  Outputs: X0=%b, X1=%b",
                         X0, X1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X0=%b, X1=%b",
                         expected_X0, expected_X1);
                $display("  Got:      X0=%b, X1=%b",
                         X0, X1);
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
