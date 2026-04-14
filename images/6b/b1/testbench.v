`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] n;
    wire [31:0] fact;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .n(n),
        .fact(fact)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: n = 0", test_num);
            n = 32'd0;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: n = 1", test_num);
            n = 32'd1;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: n = 2", test_num);
            n = 32'd2;
            #1;

            check_outputs(32'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: n = 5", test_num);
            n = 32'd5;
            #1;

            check_outputs(32'd120);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: n = 8", test_num);
            n = 32'd8;
            #1;

            check_outputs(32'd40320);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: n = 10", test_num);
            n = 32'd10;
            #1;

            check_outputs(32'd3628800);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: n = 12 (Upper Bound)", test_num);
            n = 32'd12;
            #1;

            check_outputs(32'd479001600);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: n = 13 (Out of Range)", test_num);
            n = 32'd13;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: n = 100 (Large Out of Range)", test_num);
            n = 32'd100;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: n = 0xFFFFFFFF (Edge Case)", test_num);
            n = 32'hFFFFFFFF;
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_fact;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fact === (expected_fact ^ fact ^ expected_fact)) begin
                $display("PASS");
                $display("  Outputs: fact=%h",
                         fact);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fact=%h",
                         expected_fact);
                $display("  Got:      fact=%h",
                         fact);
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
