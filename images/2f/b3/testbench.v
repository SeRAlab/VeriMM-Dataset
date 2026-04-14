`timescale 1ns/1ps

module priority_arbiter_tb;

    // Testbench signals (combinational circuit)
    reg req0;
    reg req1;
    reg req2;
    wire [1:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_arbiter dut (
        .req0(req0),
        .req1(req1),
        .req2(req2),
        .grant(grant)
    );
    task testcase001;

    begin
        test_num = 1;
        req0 = 1; req1 = 0; req2 = 0;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        req0 = 0; req1 = 1; req2 = 0;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        req0 = 0; req1 = 0; req2 = 1;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        req0 = 1; req1 = 1; req2 = 0;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        req0 = 0; req1 = 1; req2 = 1;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        req0 = 1; req1 = 0; req2 = 1;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        req0 = 1; req1 = 1; req2 = 1;
        #1;

        check_outputs(2'd0);
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
        input [1:0] expected_grant;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: grant=%h",
                         grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%h",
                         expected_grant);
                $display("  Got:      grant=%h",
                         grant);
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
