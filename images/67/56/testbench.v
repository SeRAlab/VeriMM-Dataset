`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg x;
    reg [3:0] y;
    wire Y1;
    wire Y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .Y1(Y1),
        .Y3(Y3)
    );
    task testcase001;

        begin
            $display("Running testcase001: State M (0001), x=0");
            test_num = 1;
            y = 4'b0001;
            x = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: State M (0001), x=1");
            test_num = 2;
            y = 4'b0001;
            x = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: State N (0010), x=0");
            test_num = 3;
            y = 4'b0010;
            x = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: State N (0010), x=1");
            test_num = 4;
            y = 4'b0010;
            x = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: State O (0100), x=0");
            test_num = 5;
            y = 4'b0100;
            x = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: State O (0100), x=1");
            test_num = 6;
            y = 4'b0100;
            x = 1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: State P (1000), x=0");
            test_num = 7;
            y = 4'b1000;
            x = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: State P (1000), x=1");
            test_num = 8;
            y = 4'b1000;
            x = 1;
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
        input expected_Y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3)) begin
                $display("PASS");
                $display("  Outputs: Y1=%b, Y3=%b",
                         Y1, Y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y1=%b, Y3=%b",
                         expected_Y1, expected_Y3);
                $display("  Got:      Y1=%b, Y3=%b",
                         Y1, Y3);
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
