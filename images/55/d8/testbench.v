`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] t;
    reg x;
    wire T3;
    wire T4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .t(t),
        .x(x),
        .T3(T3),
        .T4(T4)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: State P (0001), x=0 -> Expect T3=0, T4=0", test_num);
            t = 4'b0001; x = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State P (0001), x=1 -> Expect T3=1, T4=0 (P to R)", test_num);
            t = 4'b0001; x = 1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State Q (0010), x=0 -> Expect T3=0, T4=0", test_num);
            t = 4'b0010; x = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State Q (0010), x=1 -> Expect T3=0, T4=1 (Q to S)", test_num);
            t = 4'b0010; x = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: State R (0100), x=0 -> Expect T3=0, T4=1 (R to S)", test_num);
            t = 4'b0100; x = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State R (0100), x=1 -> Expect T3=0, T4=0", test_num);
            t = 4'b0100; x = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: State S (1000), x=0 -> Expect T3=0, T4=0", test_num);
            t = 4'b1000; x = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: State S (1000), x=1 -> Expect T3=1, T4=0 (S to R)", test_num);
            t = 4'b1000; x = 1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Invalid State (0000), x=1 -> Expect T3=0, T4=0", test_num);
            t = 4'b0000; x = 1;
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
        input expected_T3;
        input expected_T4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_T3 === (expected_T3 ^ T3 ^ expected_T3) &&
                expected_T4 === (expected_T4 ^ T4 ^ expected_T4)) begin
                $display("PASS");
                $display("  Outputs: T3=%b, T4=%b",
                         T3, T4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: T3=%b, T4=%b",
                         expected_T3, expected_T4);
                $display("  Got:      T3=%b, T4=%b",
                         T3, T4);
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
