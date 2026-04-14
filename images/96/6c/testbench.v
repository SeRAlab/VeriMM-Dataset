`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg S0;
    reg S1;
    reg VGND;
    reg VPWR;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .S0(S0),
        .S1(S1),
        .VGND(VGND),
        .VPWR(VPWR),
        .X(X)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A0 (S1=0, S0=0), set A0=1", test_num);
            VPWR = 1; VGND = 0;
            S1 = 0; S0 = 0;
            A0 = 1; A1 = 0; A2 = 0; A3 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A0 (S1=0, S0=0), set A0=0 (others=1)", test_num);
            VPWR = 1; VGND = 0;
            S1 = 0; S0 = 0;
            A0 = 0; A1 = 1; A2 = 1; A3 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A1 (S1=0, S0=1), set A1=1", test_num);
            VPWR = 1; VGND = 0;
            S1 = 0; S0 = 1;
            A0 = 0; A1 = 1; A2 = 0; A3 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A1 (S1=0, S0=1), set A1=0 (others=1)", test_num);
            VPWR = 1; VGND = 0;
            S1 = 0; S0 = 1;
            A0 = 1; A1 = 0; A2 = 1; A3 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A2 (S1=1, S0=0), set A2=1", test_num);
            VPWR = 1; VGND = 0;
            S1 = 1; S0 = 0;
            A0 = 0; A1 = 0; A2 = 1; A3 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A2 (S1=1, S0=0), set A2=0 (others=1)", test_num);
            VPWR = 1; VGND = 0;
            S1 = 1; S0 = 0;
            A0 = 1; A1 = 1; A2 = 0; A3 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A3 (S1=1, S0=1), set A3=1", test_num);
            VPWR = 1; VGND = 0;
            S1 = 1; S0 = 1;
            A0 = 0; A1 = 0; A2 = 0; A3 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A3 (S1=1, S0=1), set A3=0 (others=1)", test_num);
            VPWR = 1; VGND = 0;
            S1 = 1; S0 = 1;
            A0 = 1; A1 = 1; A2 = 1; A3 = 0;
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
