`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg din2_gt_din1_hi;
    reg din2_gt_din1_lo;
    reg din2_gt_din1_mid;
    reg din2_neq_din1_hi;
    reg din2_neq_din1_lo;
    reg din2_neq_din1_mid;
    wire din2_gt_din1;
    wire din2_neq_din1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din2_gt_din1_hi(din2_gt_din1_hi),
        .din2_gt_din1_lo(din2_gt_din1_lo),
        .din2_gt_din1_mid(din2_gt_din1_mid),
        .din2_neq_din1_hi(din2_neq_din1_hi),
        .din2_neq_din1_lo(din2_neq_din1_lo),
        .din2_neq_din1_mid(din2_neq_din1_mid),
        .din2_gt_din1(din2_gt_din1),
        .din2_neq_din1(din2_neq_din1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All levels equal", test_num);
            din2_neq_din1_hi = 0; din2_gt_din1_hi = 0;
            din2_neq_din1_mid = 0; din2_gt_din1_mid = 0;
            din2_neq_din1_lo = 0; din2_gt_din1_lo = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: High level Greater Than", test_num);
            din2_neq_din1_hi = 1; din2_gt_din1_hi = 1;
            din2_neq_din1_mid = 0; din2_gt_din1_mid = 0;
            din2_neq_din1_lo = 0; din2_gt_din1_lo = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: High level Less Than", test_num);
            din2_neq_din1_hi = 1; din2_gt_din1_hi = 0;
            din2_neq_din1_mid = 0; din2_gt_din1_mid = 0;
            din2_neq_din1_lo = 0; din2_gt_din1_lo = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: High Equal, Mid Greater Than", test_num);
            din2_neq_din1_hi = 0; din2_gt_din1_hi = 0;
            din2_neq_din1_mid = 1; din2_gt_din1_mid = 1;
            din2_neq_din1_lo = 0; din2_gt_din1_lo = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: High Equal, Mid Less Than", test_num);
            din2_neq_din1_hi = 0; din2_gt_din1_hi = 0;
            din2_neq_din1_mid = 1; din2_gt_din1_mid = 0;
            din2_neq_din1_lo = 0; din2_gt_din1_lo = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: High/Mid Equal, Low Greater Than", test_num);
            din2_neq_din1_hi = 0; din2_gt_din1_hi = 0;
            din2_neq_din1_mid = 0; din2_gt_din1_mid = 0;
            din2_neq_din1_lo = 1; din2_gt_din1_lo = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: High/Mid Equal, Low Less Than", test_num);
            din2_neq_din1_hi = 0; din2_gt_din1_hi = 0;
            din2_neq_din1_mid = 0; din2_gt_din1_mid = 0;
            din2_neq_din1_lo = 1; din2_gt_din1_lo = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Priority Check (High Overrides Mid/Low)", test_num);


            din2_neq_din1_hi = 1; din2_gt_din1_hi = 1;
            din2_neq_din1_mid = 1; din2_gt_din1_mid = 0;
            din2_neq_din1_lo = 1; din2_gt_din1_lo = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Priority Check (Mid Overrides Low)", test_num);


            din2_neq_din1_hi = 0; din2_gt_din1_hi = 0;
            din2_neq_din1_mid = 1; din2_gt_din1_mid = 0;
            din2_neq_din1_lo = 1; din2_gt_din1_lo = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Any inequality causes overall neq", test_num);

            din2_neq_din1_hi = 0; din2_gt_din1_hi = 0;
            din2_neq_din1_mid = 0; din2_gt_din1_mid = 0;
            din2_neq_din1_lo = 1; din2_gt_din1_lo = 0;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_din2_gt_din1;
        input expected_din2_neq_din1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_din2_gt_din1 === (expected_din2_gt_din1 ^ din2_gt_din1 ^ expected_din2_gt_din1) &&
                expected_din2_neq_din1 === (expected_din2_neq_din1 ^ din2_neq_din1 ^ expected_din2_neq_din1)) begin
                $display("PASS");
                $display("  Outputs: din2_gt_din1=%b, din2_neq_din1=%b",
                         din2_gt_din1, din2_neq_din1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din2_gt_din1=%b, din2_neq_din1=%b",
                         expected_din2_gt_din1, expected_din2_neq_din1);
                $display("  Got:      din2_gt_din1=%b, din2_neq_din1=%b",
                         din2_gt_din1, din2_neq_din1);
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
