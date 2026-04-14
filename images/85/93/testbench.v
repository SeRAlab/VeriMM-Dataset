`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg p;
    reg [3:0] z;
    wire Z2;
    wire Z3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p(p),
        .z(z),
        .Z2(Z2),
        .Z3(Z3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            p = 1'b0;
            z = 4'b0001;
            $display("Testcase %03d: State Q (4'b0001), p=0. Expecting transition to R (Z2=1, Z3=0)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            p = 1'b1;
            z = 4'b0001;
            $display("Testcase %03d: State Q (4'b0001), p=1. Expecting transition to S (Z2=0, Z3=1)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            p = 1'b0;
            z = 4'b0010;
            $display("Testcase %03d: State R (4'b0010), p=0. Expecting transition to Q (Z2=0, Z3=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            p = 1'b1;
            z = 4'b0010;
            $display("Testcase %03d: State R (4'b0010), p=1. Expecting transition to T (Z2=0, Z3=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            p = 1'b0;
            z = 4'b0100;
            $display("Testcase %03d: State S (4'b0100), p=0. Expecting transition to T (Z2=0, Z3=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            p = 1'b1;
            z = 4'b0100;
            $display("Testcase %03d: State S (4'b0100), p=1. Expecting transition to Q (Z2=0, Z3=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            p = 1'b0;
            z = 4'b1000;
            $display("Testcase %03d: State T (4'b1000), p=0. Expecting transition to S (Z2=0, Z3=1)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            p = 1'b1;
            z = 4'b1000;
            $display("Testcase %03d: State T (4'b1000), p=1. Expecting transition to R (Z2=1, Z3=0)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            p = 1'b0;
            z = 4'b0000;
            $display("Testcase %03d: Invalid state (0000), p=0. Expecting Z2=0, Z3=0", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            p = 1'b0;
            z = 4'b1001;
            $display("Testcase %03d: Q and T active (1001), p=0. Expecting Z2=1, Z3=1", test_num);
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
        input expected_Z2;
        input expected_Z3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z2 === (expected_Z2 ^ Z2 ^ expected_Z2) &&
                expected_Z3 === (expected_Z3 ^ Z3 ^ expected_Z3)) begin
                $display("PASS");
                $display("  Outputs: Z2=%b, Z3=%b",
                         Z2, Z3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z2=%b, Z3=%b",
                         expected_Z2, expected_Z3);
                $display("  Got:      Z2=%b, Z3=%b",
                         Z2, Z3);
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
