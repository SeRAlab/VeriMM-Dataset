`timescale 1ns/1ps

module PriorityArbiter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] req;
    wire [4:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PriorityArbiter dut (
        .req(req),
        .grant(grant)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: No requests", test_num);
        req = 5'b00000;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Only highest priority request (req[0])", test_num);
        req = 5'b00001;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Only lowest priority request (req[4])", test_num);
        req = 5'b10000;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Multiple requests (req[0] and req[1]) - req[0] should win", test_num);
        req = 5'b00011;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Multiple requests (req[2], req[3], req[4]) - req[2] should win", test_num);
        req = 5'b11100;
        #1;

        check_outputs(5'b00100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Non-contiguous requests (req[1] and req[3]) - req[1] should win", test_num);
        req = 5'b01010;
        #1;

        check_outputs(5'b00010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: All requests active - req[0] should win", test_num);
        req = 5'b11111;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Middle priority request (req[2])", test_num);
        req = 5'b00100;
        #1;

        check_outputs(5'b00100);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Sparse requests (req[1], req[4]) - req[1] should win", test_num);
        req = 5'b10010;
        #1;

        check_outputs(5'b00010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PriorityArbiter Testbench");
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
        input [4:0] expected_grant;
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
