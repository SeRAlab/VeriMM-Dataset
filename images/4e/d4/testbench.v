`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg t;
    reg [3:0] u;
    wire U3;
    wire U4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .t(t),
        .u(u),
        .U3(U3),
        .U4(U4)
    );
    task testcase001;

        begin
            $display("Testcase 001: State P, t=0");
            test_num = 1;
            u = 4'b0001;
            t = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: State P, t=1");
            test_num = 2;
            u = 4'b0001;
            t = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: State Q, t=0");
            test_num = 3;
            u = 4'b0010;
            t = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: State Q, t=1");
            test_num = 4;
            u = 4'b0010;
            t = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: State R, t=0");
            test_num = 5;
            u = 4'b0100;
            t = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: State R, t=1");
            test_num = 6;
            u = 4'b0100;
            t = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: State S, t=0");
            test_num = 7;
            u = 4'b1000;
            t = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: State S, t=1");
            test_num = 8;
            u = 4'b1000;
            t = 1'b1;
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
        input expected_U3;
        input expected_U4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_U3 === (expected_U3 ^ U3 ^ expected_U3) &&
                expected_U4 === (expected_U4 ^ U4 ^ expected_U4)) begin
                $display("PASS");
                $display("  Outputs: U3=%b, U4=%b",
                         U3, U4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: U3=%b, U4=%b",
                         expected_U3, expected_U4);
                $display("  Got:      U3=%b, U4=%b",
                         U3, U4);
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
