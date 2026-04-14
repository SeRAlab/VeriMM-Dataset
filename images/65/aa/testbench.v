`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg TE;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .TE(TE),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: TE=0 (Disabled)");

        A = 0; B = 0; C = 0; D = 0; TE = 0;
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        #10;

        A = 1; B = 1; C = 1; D = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: TE=1, All Inputs Low");

        A = 0; B = 0; C = 0; D = 0; TE = 0;
        #10;

        TE = 1;
        A = 0; B = 0; C = 0; D = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: TE=1, Input A High");
        A = 0; B = 0; C = 0; D = 0; TE = 0;
        #10;
        TE = 1;
        A = 1; B = 0; C = 0; D = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: TE=1, Input B High");
        A = 0; B = 0; C = 0; D = 0; TE = 0;
        #10;
        TE = 1;
        A = 0; B = 1; C = 0; D = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: TE=1, Input C High");
        A = 0; B = 0; C = 0; D = 0; TE = 0;
        #10;
        TE = 1;
        A = 0; B = 0; C = 1; D = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: TE=1, Input D High");
        A = 0; B = 0; C = 0; D = 0; TE = 0;
        #10;
        TE = 1;
        A = 0; B = 0; C = 0; D = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: TE=1, Multiple Inputs High");
        A = 0; B = 0; C = 0; D = 0; TE = 0;
        #10;
        TE = 1;
        A = 1; B = 0; C = 1; D = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: TE=1, All Inputs High");
        A = 0; B = 0; C = 0; D = 0; TE = 0;
        #10;
        TE = 1;
        A = 1; B = 1; C = 1; D = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Dynamic transition to 0");
        A = 1; B = 1; C = 1; D = 1; TE = 1;
        #10;
        A = 0; B = 0; C = 0; D = 0;
        #10;
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
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%b",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b",
                         expected_Z);
                $display("  Got:      Z=%b",
                         Z);
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
