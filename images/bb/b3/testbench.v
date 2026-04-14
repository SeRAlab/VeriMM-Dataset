`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg u;
    reg [3:0] v;
    wire V3;
    wire V4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .u(u),
        .v(v),
        .V3(V3),
        .V4(V4)
    );
    task testcase001;

    begin
        $display("Testcase 001: State M (v=0001), u=0 -> Next State N");
        u = 1'b0;
        v = 4'b0001;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: State M (v=0001), u=1 -> Next State O");
        u = 1'b1;
        v = 4'b0001;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: State N (v=0010), u=0 -> Next State M");
        u = 1'b0;
        v = 4'b0010;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: State N (v=0010), u=1 -> Next State P");
        u = 1'b1;
        v = 4'b0010;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: State O (v=0100), u=0 -> Next State P");
        u = 1'b0;
        v = 4'b0100;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: State O (v=0100), u=1 -> Next State M");
        u = 1'b1;
        v = 4'b0100;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: State P (v=1000), u=0 -> Next State N");
        u = 1'b0;
        v = 4'b1000;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: State P (v=1000), u=1 -> Next State O");
        u = 1'b1;
        v = 4'b1000;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Invalid state (all zero), u=1 -> No transition to O or P");
        u = 1'b1;
        v = 4'b0000;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Invalid state (all ones), u=1 -> Logic should produce 1s based on derivation");
        u = 1'b1;
        v = 4'b1111;
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_V3;
        input expected_V4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V3 === (expected_V3 ^ V3 ^ expected_V3) &&
                expected_V4 === (expected_V4 ^ V4 ^ expected_V4)) begin
                $display("PASS");
                $display("  Outputs: V3=%b, V4=%b",
                         V3, V4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V3=%b, V4=%b",
                         expected_V3, expected_V4);
                $display("  Got:      V3=%b, V4=%b",
                         V3, V4);
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
