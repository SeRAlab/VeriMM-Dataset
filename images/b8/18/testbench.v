`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C_N;
    reg VGND;
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
        .C_N(C_N),
        .VGND(VGND),
        .VPWR(VPWR),
        .X(X)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 0; B = 0; C_N = 0;
            VPWR = 1; VGND = 0;
            $display("Test Case %0d: A=0, B=0, C_N=0 (C active) -> Expected X=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 0; B = 0; C_N = 1;
            VPWR = 1; VGND = 0;
            $display("Test Case %0d: A=0, B=0, C_N=1 (None active) -> Expected X=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 0; B = 1; C_N = 0;
            VPWR = 1; VGND = 0;
            $display("Test Case %0d: A=0, B=1, C_N=0 (B, C active) -> Expected X=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 0; B = 1; C_N = 1;
            VPWR = 1; VGND = 0;
            $display("Test Case %0d: A=0, B=1, C_N=1 (B active) -> Expected X=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 1; B = 0; C_N = 0;
            VPWR = 1; VGND = 0;
            $display("Test Case %0d: A=1, B=0, C_N=0 (A, C active) -> Expected X=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 1; B = 0; C_N = 1;
            VPWR = 1; VGND = 0;
            $display("Test Case %0d: A=1, B=0, C_N=1 (A active) -> Expected X=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 1; B = 1; C_N = 0;
            VPWR = 1; VGND = 0;
            $display("Test Case %0d: A=1, B=1, C_N=0 (All active) -> Expected X=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 1; B = 1; C_N = 1;
            VPWR = 1; VGND = 0;
            $display("Test Case %0d: A=1, B=1, C_N=1 (A, B active) -> Expected X=1", test_num);
            #1;

            check_outputs(1);
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
