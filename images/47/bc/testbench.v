`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] e;
    reg x;
    wire E2;
    wire E3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e(e),
        .x(x),
        .E2(E2),
        .E3(E3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: State A (e=3'b001), x=0 -> Expecting transition to State B (E2=1, E3=0)", test_num);
        e = 3'b001;
        x = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: State A (e=3'b001), x=1 -> Expecting transition to State C (E2=0, E3=1)", test_num);
        e = 3'b001;
        x = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: State B (e=3'b010), x=0 -> Expecting transition to State A (E2=0, E3=0)", test_num);
        e = 3'b010;
        x = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: State B (e=3'b010), x=1 -> Expecting transition to State C (E2=0, E3=1)", test_num);
        e = 3'b010;
        x = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: State C (e=3'b100), x=0 -> Expecting transition to State B (E2=1, E3=0)", test_num);
        e = 3'b100;
        x = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: State C (e=3'b100), x=1 -> Expecting transition to State A (E2=0, E3=0)", test_num);
        e = 3'b100;
        x = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: All Inputs Zero (e=3'b000), x=0 -> Expecting no high outputs (E2=0, E3=0)", test_num);
        e = 3'b000;
        x = 0;
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
        input expected_E2;
        input expected_E3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_E2 === (expected_E2 ^ E2 ^ expected_E2) &&
                expected_E3 === (expected_E3 ^ E3 ^ expected_E3)) begin
                $display("PASS");
                $display("  Outputs: E2=%b, E3=%b",
                         E2, E3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E2=%b, E3=%b",
                         expected_E2, expected_E3);
                $display("  Got:      E2=%b, E3=%b",
                         E2, E3);
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
