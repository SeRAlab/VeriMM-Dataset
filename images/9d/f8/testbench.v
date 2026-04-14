`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [98:0] request;
    wire [98:0] await;
    wire [98:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .request(request),
        .await(await),
        .grant(grant)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No requests", test_num);
            request = 99'b0;
            #1;

            check_outputs(99'b0, 99'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Highest priority request only", test_num);
            request = (99'h1 << 98);
            #1;

            check_outputs(99'b0, (99'h1 << 98));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Lowest priority request only", test_num);
            request = 99'h1;
            #1;

            check_outputs(99'b0, 99'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority conflict (98 and 0)", test_num);
            request = (99'h1 << 98) | 99'h1;

            #1;


            check_outputs(99'h1, (99'h1 << 98));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Middle bit request (bit 50)", test_num);
            request = (99'h1 << 50);
            #1;

            check_outputs(99'b0, (99'h1 << 50));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple requests (50, 40, 10)", test_num);
            request = (99'h1 << 50) | (99'h1 << 40) | (99'h1 << 10);

            #1;


            check_outputs((99'h1 << 40) | (99'h1 << 10), (99'h1 << 50));
        end
        endtask

    task testcase007;

        reg [98:0] expected_await;
        begin
            test_num = test_num + 1;
            $display("Test %0d: All bits requested", test_num);
            request = {99{1'b1}};

            expected_await = {99{1'b1}} & ~(99'h1 << 98);
            #1;

            check_outputs(expected_await, (99'h1 << 98));
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
        input [98:0] expected_await;
        input [98:0] expected_grant;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_await === (expected_await ^ await ^ expected_await) &&
                expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: await=%h, grant=%h",
                         await, grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: await=%h, grant=%h",
                         expected_await, expected_grant);
                $display("  Got:      await=%h, grant=%h",
                         await, grant);
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
