`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg j;
    reg [2:0] p;
    wire P2;
    wire P3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .j(j),
        .p(p),
        .P2(P2),
        .P3(P3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Current State N (p=001), j=0 -> Expected Next State O (P2=1, P3=0)", test_num);
            p = 3'b001;
            j = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Current State N (p=001), j=1 -> Expected Next State P (P2=0, P3=1)", test_num);
            p = 3'b001;
            j = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Current State O (p=010), j=0 -> Expected Next State P (P2=0, P3=1)", test_num);
            p = 3'b010;
            j = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Current State O (p=010), j=1 -> Expected Next State N (P2=0, P3=0)", test_num);
            p = 3'b010;
            j = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Current State P (p=100), j=0 -> Expected Next State N (P2=0, P3=0)", test_num);
            p = 3'b100;
            j = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Current State P (p=100), j=1 -> Expected Next State O (P2=1, P3=0)", test_num);
            p = 3'b100;
            j = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: All zero state (invalid), j=0 -> Expected P2=0, P3=0", test_num);
            p = 3'b000;
            j = 1'b0;
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
        input expected_P2;
        input expected_P3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P2 === (expected_P2 ^ P2 ^ expected_P2) &&
                expected_P3 === (expected_P3 ^ P3 ^ expected_P3)) begin
                $display("PASS");
                $display("  Outputs: P2=%b, P3=%b",
                         P2, P3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P2=%b, P3=%b",
                         expected_P2, expected_P3);
                $display("  Got:      P2=%b, P3=%b",
                         P2, P3);
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
