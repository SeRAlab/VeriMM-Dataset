`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] base;
    reg [15:0] req;
    wire [15:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .base(base),
        .req(req),
        .grant(grant)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            req = 16'h0000;
            base = 16'h0001;
            $display("\nTestcase %0d: No requests active", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            req = 16'h0001;
            base = 16'h0001;
            $display("\nTestcase %0d: Single request at base position", test_num);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            req = 16'h0004;
            base = 16'h0001;
            $display("\nTestcase %0d: Single request after base position", test_num);
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            req = 16'h0001;
            base = 16'h0002;
            $display("\nTestcase %0d: Single request before base (wrap-around)", test_num);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            req = 16'h0007;
            base = 16'h0002;
            $display("\nTestcase %0d: Multiple requests, priority at bit 1", test_num);
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            req = 16'h0005;
            base = 16'h0002;
            $display("\nTestcase %0d: Multiple requests (0,2), base at 1, should pick bit 2", test_num);
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            req = 16'h0007;
            base = 16'h0008;
            $display("\nTestcase %0d: Wrap-around to the beginning of the vector", test_num);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            req = 16'hFFFF;
            base = 16'h0001;
            $display("\nTestcase %0d: All requests active, base at bit 0", test_num);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            req = 16'hFFFF;
            base = 16'h0100;
            $display("\nTestcase %0d: All requests active, base in middle (bit 8)", test_num);
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            req = 16'h8001;
            base = 16'h8000;
            $display("\nTestcase %0d: High bit request and base active", test_num);
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            req = 16'hA00A;
            base = 16'h4000;
            $display("\nTestcase %0d: Sparse requests, base between 13 and 15", test_num);

            #1;


            check_outputs(16'h8000);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            req = 16'hA00A;
            base = 16'hFFFF;
            $display("\nTestcase %0d: Base at bit 15, request at bit 15 exists", test_num);
            #1;

            check_outputs(16'h8000);
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
        input [15:0] expected_grant;
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
