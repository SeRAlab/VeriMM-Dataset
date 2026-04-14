`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D_N;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D_N(D_N),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .X(X)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: All logic inputs low, control enabled (D_N=0), power OK");
        A = 0; B = 0; C = 0; D_N = 0;
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Input A high, others low, power OK");
        A = 1; B = 0; C = 0; D_N = 0;
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Input B high, others low, power OK");
        A = 0; B = 1; C = 0; D_N = 0;
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Input C high, others low, power OK");
        A = 0; B = 0; C = 1; D_N = 0;
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Control D_N high (negated to disable output), power OK");
        A = 0; B = 0; C = 0; D_N = 1;
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Multiple inputs high (A and B), power OK");
        A = 1; B = 1; C = 0; D_N = 0;
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Valid logic but VPWR failure (0V)");
        A = 0; B = 0; C = 0; D_N = 0;
        VPWR = 0; VGND = 0; VPB = 1; VNB = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Valid logic but VGND failure (Float/High)");
        A = 0; B = 0; C = 0; D_N = 0;
        VPWR = 1; VGND = 1; VPB = 1; VNB = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase 009: Valid logic but VPB (P-Bias) failure");
        A = 0; B = 0; C = 0; D_N = 0;
        VPWR = 1; VGND = 0; VPB = 0; VNB = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase 010: Valid logic but VNB (N-Bias) failure");
        A = 0; B = 0; C = 0; D_N = 0;
        VPWR = 1; VGND = 0; VPB = 1; VNB = 1;
        #1;

        check_outputs(0);
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
