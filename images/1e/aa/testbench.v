`timescale 1ns/1ps

module priority_arbiter_tb;

    // Testbench signals (combinational circuit)
    reg req0;
    reg req1;
    reg req2;
    reg req3;
    wire gnt0;
    wire gnt1;
    wire gnt2;
    wire gnt3;

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
        .gnt0(gnt0),
        .gnt1(gnt1),
        .gnt2(gnt2),
        .gnt3(gnt3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: No requests active", test_num);
        req0 = 0; req1 = 0; req2 = 0; req3 = 0;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Only req0 active", test_num);
        req0 = 1; req1 = 0; req2 = 0; req3 = 0;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Only req1 active", test_num);
        req0 = 0; req1 = 1; req2 = 0; req3 = 0;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Only req2 active", test_num);
        req0 = 0; req1 = 0; req2 = 1; req3 = 0;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Only req3 active", test_num);
        req0 = 0; req1 = 0; req2 = 0; req3 = 1;
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Multiple requests (req0, req1) - req0 should win", test_num);
        req0 = 1; req1 = 1; req2 = 0; req3 = 0;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Multiple requests (req1, req2, req3) - req1 should win", test_num);
        req0 = 0; req1 = 1; req2 = 1; req3 = 1;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Multiple requests (req2, req3) - req2 should win", test_num);
        req0 = 0; req1 = 0; req2 = 1; req3 = 1;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: All requests active - req0 should win", test_num);
        req0 = 1; req1 = 1; req2 = 1; req3 = 1;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Multiple requests (req0, req3) - req0 should win", test_num);
        req0 = 1; req1 = 0; req2 = 0; req3 = 1;
        #1;

        check_outputs(1, 0, 0, 0);
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
        input expected_gnt0;
        input expected_gnt1;
        input expected_gnt2;
        input expected_gnt3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gnt0 === (expected_gnt0 ^ gnt0 ^ expected_gnt0) &&
                expected_gnt1 === (expected_gnt1 ^ gnt1 ^ expected_gnt1) &&
                expected_gnt2 === (expected_gnt2 ^ gnt2 ^ expected_gnt2) &&
                expected_gnt3 === (expected_gnt3 ^ gnt3 ^ expected_gnt3)) begin
                $display("PASS");
                $display("  Outputs: gnt0=%b, gnt1=%b, gnt2=%b, gnt3=%b",
                         gnt0, gnt1, gnt2, gnt3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gnt0=%b, gnt1=%b, gnt2=%b, gnt3=%b",
                         expected_gnt0, expected_gnt1, expected_gnt2, expected_gnt3);
                $display("  Got:      gnt0=%b, gnt1=%b, gnt2=%b, gnt3=%b",
                         gnt0, gnt1, gnt2, gnt3);
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
