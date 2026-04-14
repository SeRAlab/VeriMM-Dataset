`timescale 1ns/1ps

module priority_arbiter_tb;

    // Testbench signals (combinational circuit)
    reg req0;
    reg req1;
    reg req2;
    reg req3;
    wire [1:0] granted;

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
        .granted(granted)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Highest priority request (req0) only", test_num);
            req0 = 1; req1 = 0; req2 = 0; req3 = 0;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Second priority request (req1) only", test_num);
            req0 = 0; req1 = 1; req2 = 0; req3 = 0;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Third priority request (req2) only", test_num);
            req0 = 0; req1 = 0; req2 = 1; req3 = 0;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Lowest priority request (req3) only", test_num);
            req0 = 0; req1 = 0; req2 = 0; req3 = 1;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple requests - req0 and req3 (req0 should win)", test_num);
            req0 = 1; req1 = 0; req2 = 0; req3 = 1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple requests - req1 and req2 (req1 should win)", test_num);
            req0 = 0; req1 = 1; req2 = 1; req3 = 0;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple requests - req2 and req3 (req2 should win)", test_num);
            req0 = 0; req1 = 0; req2 = 1; req3 = 1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All requests active (req0 should win)", test_num);
            req0 = 1; req1 = 1; req2 = 1; req3 = 1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority transition - dropping higher priority", test_num);

            req0 = 0; req1 = 1; req2 = 1; req3 = 0;
            #5;

            req1 = 0;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority transition - adding higher priority", test_num);

            req0 = 0; req1 = 0; req2 = 0; req3 = 1;
            #5;

            req1 = 1;
            #1;

            check_outputs(2'd1);
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
        input [1:0] expected_granted;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_granted === (expected_granted ^ granted ^ expected_granted)) begin
                $display("PASS");
                $display("  Outputs: granted=%h",
                         granted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: granted=%h",
                         expected_granted);
                $display("  Got:      granted=%h",
                         granted);
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
