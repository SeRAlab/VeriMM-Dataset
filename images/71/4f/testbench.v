`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 1'b0; B = 1'b0; C = 1'b0;
            #10;
            $display("Test Case 001: A=0, B=0, C=0");
            #1;

            check_outputs(TB_LUT_MASK[0]);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 1'b0; B = 1'b0; C = 1'b1;
            #10;
            $display("Test Case 002: A=0, B=0, C=1");
            #1;

            check_outputs(TB_LUT_MASK[1]);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 1'b0; B = 1'b1; C = 1'b0;
            #10;
            $display("Test Case 003: A=0, B=1, C=0");
            #1;

            check_outputs(TB_LUT_MASK[2]);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 1'b0; B = 1'b1; C = 1'b1;
            #10;
            $display("Test Case 004: A=0, B=1, C=1");
            #1;

            check_outputs(TB_LUT_MASK[3]);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 1'b1; B = 1'b0; C = 1'b0;
            #10;
            $display("Test Case 005: A=1, B=0, C=0");
            #1;

            check_outputs(TB_LUT_MASK[4]);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 1'b1; B = 1'b0; C = 1'b1;
            #10;
            $display("Test Case 006: A=1, B=0, C=1");
            #1;

            check_outputs(TB_LUT_MASK[5]);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 1'b1; B = 1'b1; C = 1'b0;
            #10;
            $display("Test Case 007: A=1, B=1, C=0");
            #1;

            check_outputs(TB_LUT_MASK[6]);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 1'b1; B = 1'b1; C = 1'b1;
            #10;
            $display("Test Case 008: A=1, B=1, C=1");
            #1;

            check_outputs(TB_LUT_MASK[7]);
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
        input expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
