`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] b;
    reg t;
    wire B2;
    wire B3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .t(t),
        .B2(B2),
        .B3(B3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: State S (001), t=0 -> Expected Next State T (B2=1, B3=0)", test_num);

            b = 3'b001;
            t = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: State S (001), t=1 -> Expected Next State U (B2=0, B3=1)", test_num);
            b = 3'b001;
            t = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: State T (010), t=0 -> Expected Next State S (B2=0, B3=0)", test_num);

            b = 3'b010;
            t = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: State T (010), t=1 -> Expected Next State U (B2=0, B3=1)", test_num);
            b = 3'b010;
            t = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: State U (100), t=0 -> Expected Next State T (B2=1, B3=0)", test_num);

            b = 3'b100;
            t = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: State U (100), t=1 -> Expected Next State S (B2=0, B3=0)", test_num);
            b = 3'b100;
            t = 1;
            #1;

            check_outputs(0, 0);
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
        input expected_B2;
        input expected_B3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B2 === (expected_B2 ^ B2 ^ expected_B2) &&
                expected_B3 === (expected_B3 ^ B3 ^ expected_B3)) begin
                $display("PASS");
                $display("  Outputs: B2=%b, B3=%b",
                         B2, B3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B2=%b, B3=%b",
                         expected_B2, expected_B3);
                $display("  Got:      B2=%b, B3=%b",
                         B2, B3);
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
