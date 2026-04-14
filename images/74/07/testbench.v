`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] y;
    reg z;
    wire Y1;
    wire Y2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .y(y),
        .z(z),
        .Y1(Y1),
        .Y2(Y2)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: State V (y=0001), z=0");
            y = 4'b0001;
            z = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: State V (y=0001), z=1");
            y = 4'b0001;
            z = 1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: State W (y=0010), z=0");
            y = 4'b0010;
            z = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: State W (y=0010), z=1");
            y = 4'b0010;
            z = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: State X (y=0100), z=0");
            y = 4'b0100;
            z = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: State X (y=0100), z=1");
            y = 4'b0100;
            z = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: State Y (y=1000), z=0");
            y = 4'b1000;
            z = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: State Y (y=1000), z=1");
            y = 4'b1000;
            z = 1;
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
        input expected_Y1;
        input expected_Y2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2)) begin
                $display("PASS");
                $display("  Outputs: Y1=%b, Y2=%b",
                         Y1, Y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y1=%b, Y2=%b",
                         expected_Y1, expected_Y2);
                $display("  Got:      Y1=%b, Y2=%b",
                         Y1, Y2);
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
