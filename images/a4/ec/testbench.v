`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    wire A;
    wire B;
    wire C;
    wire D_out;
    wire E;
    wire F;
    wire G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .A(A),
        .B(B),
        .C(C),
        .D_out(D_out),
        .E(E),
        .F(F),
        .G(G)
    );
    task testcase001;

        begin
            $display("Test Case 001: Input D=0 (0000)");
            D = 4'd0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input D=1 (0001)");
            D = 4'd1;

            #1;


            check_outputs(0, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input D=2 (0010)");
            D = 4'd2;

            #1;


            check_outputs(1, 1, 0, 1, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input D=3 (0011)");
            D = 4'd3;

            #1;


            check_outputs(1, 1, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input D=4 (0100)");
            D = 4'd4;

            #1;


            check_outputs(0, 1, 1, 0, 0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input D=5 (0101)");
            D = 4'd5;

            #1;


            check_outputs(1, 0, 1, 1, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input D=6 (0110)");
            D = 4'd6;

            #1;


            check_outputs(1, 0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input D=7 (0111)");
            D = 4'd7;

            #1;


            check_outputs(1, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Input D=8 (1000)");
            D = 4'd8;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Input D=9 (1001)");
            D = 4'd9;

            #1;


            check_outputs(1, 1, 1, 1, 0, 1, 1);
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
        input expected_A;
        input expected_B;
        input expected_C;
        input expected_D_out;
        input expected_E;
        input expected_F;
        input expected_G;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B) &&
                expected_C === (expected_C ^ C ^ expected_C) &&
                expected_D_out === (expected_D_out ^ D_out ^ expected_D_out) &&
                expected_E === (expected_E ^ E ^ expected_E) &&
                expected_F === (expected_F ^ F ^ expected_F) &&
                expected_G === (expected_G ^ G ^ expected_G)) begin
                $display("PASS");
                $display("  Outputs: A=%b, B=%b, C=%b, D_out=%b, E=%b, F=%b, G=%b",
                         A, B, C, D_out, E, F, G);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%b, B=%b, C=%b, D_out=%b, E=%b, F=%b, G=%b",
                         expected_A, expected_B, expected_C, expected_D_out, expected_E, expected_F, expected_G);
                $display("  Got:      A=%b, B=%b, C=%b, D_out=%b, E=%b, F=%b, G=%b",
                         A, B, C, D_out, E, F, G);
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
