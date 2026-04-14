`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg g1;
    reg g2;
    reg p1;
    reg p2;
    wire g;
    wire p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .g1(g1),
        .g2(g2),
        .p1(p1),
        .p2(p2),
        .g(g),
        .p(p)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            p1 = 0; p2 = 0; g1 = 0; g2 = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Block propagate active", test_num);
            p1 = 1; p2 = 1; g1 = 0; g2 = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Block generate via g2", test_num);
            p1 = 0; p2 = 0; g1 = 0; g2 = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Block generate via g1 and p2", test_num);
            p1 = 0; p2 = 1; g1 = 1; g2 = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: g1 active but p2 low", test_num);
            p1 = 0; p2 = 0; g1 = 1; g2 = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both block p and g active", test_num);
            p1 = 1; p2 = 1; g1 = 1; g2 = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs high", test_num);
            p1 = 1; p2 = 1; g1 = 1; g2 = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: g2 active, mixed p inputs", test_num);
            p1 = 1; p2 = 0; g1 = 0; g2 = 1;
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
        input expected_g;
        input expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: g=%b, p=%b",
                         g, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%b, p=%b",
                         expected_g, expected_p);
                $display("  Got:      g=%b, p=%b",
                         g, p);
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
