`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] req;
    wire [3:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .req(req),
        .grant(grant)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: No requests", test_num);
        req = 4'b0000;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Highest priority request (Bit 0)", test_num);
        req = 4'b0000;
        #10;
        req = 4'b0001;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single request (Bit 1)", test_num);
        req = 4'b0000;
        #10;
        req = 4'b0010;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Lowest priority request (Bit 3)", test_num);
        req = 4'b0000;
        #10;
        req = 4'b1000;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Contention (Bit 0 vs Bit 1)", test_num);
        req = 4'b0000;
        #10;
        req = 4'b0011;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Contention (Bit 1 vs Bit 3)", test_num);
        req = 4'b0000;
        #10;
        req = 4'b1010;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Contention (Bit 2 vs Bit 3)", test_num);
        req = 4'b0000;
        #10;
        req = 4'b1100;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All requests active", test_num);
        req = 4'b0000;
        #10;
        req = 4'b1111;
        #1;

        check_outputs(4'b0001);
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
        input [3:0] expected_grant;
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
