`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg [2:0] v;
    wire V0;
    wire V1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .v(v),
        .V0(V0),
        .V1(V1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: From State P (001), d=1 -> Next State Q (010)", test_num);
            v = 3'b001; d = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: From State P (001), d=0 -> Next State R (100)", test_num);
            v = 3'b001; d = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: From State Q (010), d=1 -> Next State P (001)", test_num);
            v = 3'b010; d = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: From State Q (010), d=0 -> Next State R (100)", test_num);
            v = 3'b010; d = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: From State R (100), d=1 -> Next State Q (010)", test_num);
            v = 3'b100; d = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: From State R (100), d=0 -> Next State P (001)", test_num);
            v = 3'b100; d = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Invalid State (000), d=1", test_num);
            v = 3'b000; d = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Multiple bits set (111), d=1", test_num);
            v = 3'b111; d = 1;


            #1;



            check_outputs(1, 1);
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
        input expected_V0;
        input expected_V1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V0 === (expected_V0 ^ V0 ^ expected_V0) &&
                expected_V1 === (expected_V1 ^ V1 ^ expected_V1)) begin
                $display("PASS");
                $display("  Outputs: V0=%b, V1=%b",
                         V0, V1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V0=%b, V1=%b",
                         expected_V0, expected_V1);
                $display("  Got:      V0=%b, V1=%b",
                         V0, V1);
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
