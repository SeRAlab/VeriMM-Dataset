`timescale 1ns/1ps

module custom_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1_N;
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
    custom_module dut (
        .A1(A1),
        .A2(A2),
        .B1_N(B1_N),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .X(X)
    );
    task testcase001;

        begin
            $display("Testcase 001: Rule 1 (A1 & A2 are both high -> X=1)");
            A1 = 1; A2 = 1; B1_N = 1; VPWR = 0; VGND = 0; VPB = 0; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Rule 2 (B1_N is low -> X=0)");
            A1 = 0; A2 = 1; B1_N = 0; VPWR = 0; VGND = 0; VPB = 0; VNB = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Rule 3 (VPWR high, VGND low -> X=1)");
            A1 = 0; A2 = 0; B1_N = 1; VPWR = 1; VGND = 0; VPB = 0; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Rule 4 (VPB high, VNB low -> X=0)");
            A1 = 0; A2 = 0; B1_N = 1; VPWR = 0; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Default Case (None met -> X=1)");
            A1 = 0; A2 = 0; B1_N = 1; VPWR = 0; VGND = 1; VPB = 0; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Priority 1 vs 2 (A1,A2=1 and B1_N=0 -> Rule 1 wins X=1)");
            A1 = 1; A2 = 1; B1_N = 0; VPWR = 0; VGND = 0; VPB = 0; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Priority 2 vs 3 (B1_N=0 and VPWR/VGND set -> Rule 2 wins X=0)");
            A1 = 0; A2 = 0; B1_N = 0; VPWR = 1; VGND = 0; VPB = 0; VNB = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Priority 3 vs 4 (VPWR/VGND set and VPB/VNB set -> Rule 3 wins X=1)");
            A1 = 0; A2 = 0; B1_N = 1; VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Rule 3 Failure Check (VPWR=1, VGND=1 -> Rule 3 fails)");
            A1 = 0; A2 = 0; B1_N = 1; VPWR = 1; VGND = 1; VPB = 0; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Rule 4 Failure Check (VPB=1, VNB=1 -> Rule 4 fails)");
            A1 = 0; A2 = 0; B1_N = 1; VPWR = 0; VGND = 0; VPB = 1; VNB = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("custom_module Testbench");
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
