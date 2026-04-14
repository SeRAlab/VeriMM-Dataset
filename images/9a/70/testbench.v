`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] l;
    reg p;
    wire L2;
    wire L3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .l(l),
        .p(p),
        .L2(L2),
        .L3(L3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: From State P (001) with p=0 -> Next State Q (010)", test_num);

            l = 3'b001;
            p = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: From State P (001) with p=1 -> Next State R (100)", test_num);

            l = 3'b001;
            p = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: From State Q (010) with p=0 -> Next State P (001)", test_num);

            l = 3'b010;
            p = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: From State Q (010) with p=1 -> Next State R (100)", test_num);

            l = 3'b010;
            p = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: From State R (100) with p=0 -> Next State Q (010)", test_num);

            l = 3'b100;
            p = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: From State R (100) with p=1 -> Next State P (001)", test_num);

            l = 3'b100;
            p = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Illegal state check (all zero) with p=0", test_num);
            l = 3'b000;
            p = 1'b0;
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
        input expected_L2;
        input expected_L3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L2 === (expected_L2 ^ L2 ^ expected_L2) &&
                expected_L3 === (expected_L3 ^ L3 ^ expected_L3)) begin
                $display("PASS");
                $display("  Outputs: L2=%b, L3=%b",
                         L2, L3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L2=%b, L3=%b",
                         expected_L2, expected_L3);
                $display("  Got:      L2=%b, L3=%b",
                         L2, L3);
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
