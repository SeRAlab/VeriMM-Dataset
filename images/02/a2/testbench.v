`timescale 1ns/1ps

module priority_arbiter_tb;

    // Testbench signals (combinational circuit)
    reg req0;
    reg req1;
    reg req2;
    reg req3;
    wire grant0;
    wire grant1;
    wire grant2;
    wire grant3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_arbiter dut (
        .req0(req0),
        .req1(req1),
        .req2(req2),
        .req3(req3),
        .grant0(grant0),
        .grant1(grant1),
        .grant2(grant2),
        .grant3(grant3)
    );
    task testcase001;

    begin
        $display("Test Case 001: No requests");
        req0 = 0; req1 = 0; req2 = 0; req3 = 0;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Only req0 (Highest Priority)");
        req0 = 1; req1 = 0; req2 = 0; req3 = 0;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Only req1");
        req0 = 0; req1 = 1; req2 = 0; req3 = 0;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Only req2");
        req0 = 0; req1 = 0; req2 = 1; req3 = 0;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Only req3 (Lowest Priority)");
        req0 = 0; req1 = 0; req2 = 0; req3 = 1;
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: req0 and req1 (req0 should win)");
        req0 = 1; req1 = 1; req2 = 0; req3 = 0;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: req1 and req2 (req1 should win)");
        req0 = 0; req1 = 1; req2 = 1; req3 = 0;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: req2 and req3 (req2 should win)");
        req0 = 0; req1 = 0; req2 = 1; req3 = 1;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: req0 and req3 (req0 should win)");
        req0 = 1; req1 = 0; req2 = 0; req3 = 1;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: req1 and req3 (req1 should win)");
        req0 = 0; req1 = 1; req2 = 0; req3 = 1;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase011;

    begin
        $display("Test Case 011: All requests active (req0 should win)");
        req0 = 1; req1 = 1; req2 = 1; req3 = 1;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase012;

    begin
        $display("Test Case 012: req1, req2, and req3 active (req1 should win)");
        req0 = 0; req1 = 1; req2 = 1; req3 = 1;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_arbiter Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input expected_grant3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_grant0 === (expected_grant0 ^ grant0 ^ expected_grant0) &&
                expected_grant1 === (expected_grant1 ^ grant1 ^ expected_grant1) &&
                expected_grant2 === (expected_grant2 ^ grant2 ^ expected_grant2) &&
                expected_grant3 === (expected_grant3 ^ grant3 ^ expected_grant3)) begin
                $display("PASS");
                $display("  Outputs: grant0=%b, grant1=%b, grant2=%b, grant3=%b",
                         grant0, grant1, grant2, grant3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant0=%b, grant1=%b, grant2=%b, grant3=%b",
                         expected_grant0, expected_grant1, expected_grant2, expected_grant3);
                $display("  Got:      grant0=%b, grant1=%b, grant2=%b, grant3=%b",
                         grant0, grant1, grant2, grant3);
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
