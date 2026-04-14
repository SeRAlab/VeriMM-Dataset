`timescale 1ns/1ps

module Comparator64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire A_eq_B;
    wire A_gt_B;
    wire A_lt_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Comparator64 dut (
        .A(A),
        .B(B),
        .A_eq_B(A_eq_B),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All zeros (Equality)", test_num);
            A = 64'h0000_0000_0000_0000;
            B = 64'h0000_0000_0000_0000;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ones (Equality)", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'hFFFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: LSB difference (A > B)", test_num);
            A = 64'h0000_0000_0000_0001;
            B = 64'h0000_0000_0000_0000;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: LSB difference (A < B)", test_num);
            A = 64'h0000_0000_0000_0000;
            B = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MSB difference (A > B)", test_num);
            A = 64'h8000_0000_0000_0000;
            B = 64'h7FFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MSB difference (A < B)", test_num);
            A = 64'h7FFF_FFFF_FFFF_FFFF;
            B = 64'h8000_0000_0000_0000;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random pattern (Equality)", test_num);
            A = 64'hA5A5_5A5A_1234_5678;
            B = 64'hA5A5_5A5A_1234_5678;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Difference in middle nibble (A > B)", test_num);
            A = 64'hFFFF_FFFF_8000_0000;
            B = 64'hFFFF_FFFF_7FFF_FFFF;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary values (A < B)", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFE;
            B = 64'hFFFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum vs Zero (A > B)", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'h0000_0000_0000_0000;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Comparator64 Testbench");
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
        input expected_A_eq_B;
        input expected_A_gt_B;
        input expected_A_lt_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_eq_B === (expected_A_eq_B ^ A_eq_B ^ expected_A_eq_B) &&
                expected_A_gt_B === (expected_A_gt_B ^ A_gt_B ^ expected_A_gt_B) &&
                expected_A_lt_B === (expected_A_lt_B ^ A_lt_B ^ expected_A_lt_B)) begin
                $display("PASS");
                $display("  Outputs: A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         A_eq_B, A_gt_B, A_lt_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         expected_A_eq_B, expected_A_gt_B, expected_A_lt_B);
                $display("  Got:      A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         A_eq_B, A_gt_B, A_lt_B);
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
