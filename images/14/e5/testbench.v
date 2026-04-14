`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (combinational circuit)
    reg req0;
    reg req1;
    reg req2;
    wire grant0;
    wire grant1;
    wire grant2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .req0(req0),
        .req1(req1),
        .req2(req2),
        .grant0(grant0),
        .grant1(grant1),
        .grant2(grant2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No requests active", test_num);
            req0 = 0; req1 = 0; req2 = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only req0 active", test_num);
            req0 = 1; req1 = 0; req2 = 0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only req1 active", test_num);
            req0 = 0; req1 = 1; req2 = 0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only req2 active", test_num);
            req0 = 0; req1 = 0; req2 = 1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: req0 and req1 competition", test_num);
            req0 = 1; req1 = 1; req2 = 0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: req1 and req2 competition", test_num);
            req0 = 0; req1 = 1; req2 = 1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: req0 and req2 competition", test_num);
            req0 = 1; req1 = 0; req2 = 1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All requests active", test_num);
            req0 = 1; req1 = 1; req2 = 1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_priority_arbiter Testbench");
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
        input expected_grant0;
        input expected_grant1;
        input expected_grant2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_grant0 === (expected_grant0 ^ grant0 ^ expected_grant0) &&
                expected_grant1 === (expected_grant1 ^ grant1 ^ expected_grant1) &&
                expected_grant2 === (expected_grant2 ^ grant2 ^ expected_grant2)) begin
                $display("PASS");
                $display("  Outputs: grant0=%b, grant1=%b, grant2=%b",
                         grant0, grant1, grant2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant0=%b, grant1=%b, grant2=%b",
                         expected_grant0, expected_grant1, expected_grant2);
                $display("  Got:      grant0=%b, grant1=%b, grant2=%b",
                         grant0, grant1, grant2);
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
