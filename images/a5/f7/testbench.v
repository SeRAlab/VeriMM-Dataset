`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C0;
    reg C1;
    reg C2;
    reg C3;
    reg G;
    wire L;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C0(C0),
        .C1(C1),
        .C2(C2),
        .C3(C3),
        .G(G),
        .L(L)
    );
    task testcase001;

        begin
            $display("Testcase 001: G=1 (Disabled), checking L=0");
            G = 1; A = 1; B = 1; C0 = 1; C1 = 1; C2 = 1; C3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: G=0, B=0, A=0 -> Select C0 (High)");
            G = 0; B = 0; A = 0;
            C0 = 1; C1 = 0; C2 = 0; C3 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: G=0, B=0, A=0 -> Select C0 (Low)");
            G = 0; B = 0; A = 0;
            C0 = 0; C1 = 1; C2 = 1; C3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: G=0, B=0, A=1 -> Select C1 (High)");
            G = 0; B = 0; A = 1;
            C0 = 0; C1 = 1; C2 = 0; C3 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: G=0, B=0, A=1 -> Select C1 (Low)");
            G = 0; B = 0; A = 1;
            C0 = 1; C1 = 0; C2 = 1; C3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: G=0, B=1, A=0 -> Select C2 (High)");
            G = 0; B = 1; A = 0;
            C0 = 0; C1 = 0; C2 = 1; C3 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: G=0, B=1, A=0 -> Select C2 (Low)");
            G = 0; B = 1; A = 0;
            C0 = 1; C1 = 1; C2 = 0; C3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: G=0, B=1, A=1 -> Select C3 (High)");
            G = 0; B = 1; A = 1;
            C0 = 0; C1 = 0; C2 = 0; C3 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: G=0, B=1, A=1 -> Select C3 (Low)");
            G = 0; B = 1; A = 1;
            C0 = 1; C1 = 1; C2 = 1; C3 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: G override check (B=1, A=1, C3=1, but G=1)");
            G = 1; B = 1; A = 1; C3 = 1;
            #1;

            check_outputs(1'b0);
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
        input expected_L;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L === (expected_L ^ L ^ expected_L)) begin
                $display("PASS");
                $display("  Outputs: L=%b",
                         L);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L=%b",
                         expected_L);
                $display("  Got:      L=%b",
                         L);
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
