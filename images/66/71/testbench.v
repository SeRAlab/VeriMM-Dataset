`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg G_i_k;
    reg G_km1_j;
    reg P_i_k;
    reg P_km1_j;
    wire G_i_j;
    wire P_i_j;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .G_i_k(G_i_k),
        .G_km1_j(G_km1_j),
        .P_i_k(P_i_k),
        .P_km1_j(P_km1_j),
        .G_i_j(G_i_j),
        .P_i_j(P_i_j)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            G_i_k = 0; P_i_k = 0; G_km1_j = 0; P_km1_j = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Direct Generation G_i_k = 1", test_num);
            G_i_k = 1; P_i_k = 0; G_km1_j = 0; P_km1_j = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Propagated Generation", test_num);
            G_i_k = 0; P_i_k = 1; G_km1_j = 1; P_km1_j = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Propagation Path Only", test_num);
            G_i_k = 0; P_i_k = 1; G_km1_j = 0; P_km1_j = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs High", test_num);
            G_i_k = 1; P_i_k = 1; G_km1_j = 1; P_km1_j = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Blocked Generation (P_i_k=0)", test_num);
            G_i_k = 0; P_i_k = 0; G_km1_j = 1; P_km1_j = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Blocked Propagate (P_km1_j=0)", test_num);
            G_i_k = 0; P_i_k = 1; G_km1_j = 0; P_km1_j = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Generation and Propagate Path High", test_num);
            G_i_k = 1; P_i_k = 1; G_km1_j = 0; P_km1_j = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both Propagates high, no generation", test_num);
            G_i_k = 0; P_i_k = 1; G_km1_j = 0; P_km1_j = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: G_i_k high and lower P high", test_num);
            G_i_k = 1; P_i_k = 0; G_km1_j = 0; P_km1_j = 1;
            #1;

            check_outputs(1, 0);
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
        input expected_G_i_j;
        input expected_P_i_j;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G_i_j === (expected_G_i_j ^ G_i_j ^ expected_G_i_j) &&
                expected_P_i_j === (expected_P_i_j ^ P_i_j ^ expected_P_i_j)) begin
                $display("PASS");
                $display("  Outputs: G_i_j=%b, P_i_j=%b",
                         G_i_j, P_i_j);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G_i_j=%b, P_i_j=%b",
                         expected_G_i_j, expected_P_i_j);
                $display("  Got:      G_i_j=%b, P_i_j=%b",
                         G_i_j, P_i_j);
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
