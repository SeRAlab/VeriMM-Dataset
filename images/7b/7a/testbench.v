`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A_N;
    reg B_N;
    reg C;
    reg D;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_N(A_N),
        .B_N(B_N),
        .C(C),
        .D(D),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All conditions met (A_N=0, B_N=0, C=1, D=1)", test_num);
            A_N = 0; B_N = 0; C = 1; D = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A_N is inactive (A_N=1, B_N=0, C=1, D=1)", test_num);
            A_N = 1; B_N = 0; C = 1; D = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: B_N is inactive (A_N=0, B_N=1, C=1, D=1)", test_num);
            A_N = 0; B_N = 1; C = 1; D = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: C is inactive (A_N=0, B_N=0, C=0, D=1)", test_num);
            A_N = 0; B_N = 0; C = 0; D = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: D is inactive (A_N=0, B_N=0, C=1, D=0)", test_num);
            A_N = 0; B_N = 0; C = 1; D = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Both active-low inputs false (A_N=1, B_N=1, C=1, D=1)", test_num);
            A_N = 1; B_N = 1; C = 1; D = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Both active-high inputs false (A_N=0, B_N=0, C=0, D=0)", test_num);
            A_N = 0; B_N = 0; C = 0; D = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All conditions false (A_N=1, B_N=1, C=0, D=0)", test_num);
            A_N = 1; B_N = 1; C = 0; D = 0;
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
