`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire eq;
    wire gt_a;
    wire gt_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .eq(eq),
        .gt_a(gt_a),
        .gt_b(gt_b)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0, b=0", test_num);
            a = 4'd0;
            b = 4'd0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=15, b=15", test_num);
            a = 4'd15;
            b = 4'd15;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=5, b=5", test_num);
            a = 4'd5;
            b = 4'd5;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=1, b=0", test_num);
            a = 4'd1;
            b = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=15, b=0", test_num);
            a = 4'd15;
            b = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=8, b=7", test_num);
            a = 4'd8;
            b = 4'd7;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0, b=1", test_num);
            a = 4'd0;
            b = 4'd1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0, b=15", test_num);
            a = 4'd0;
            b = 4'd15;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=7, b=8", test_num);
            a = 4'd7;
            b = 4'd8;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=10, b=5", test_num);
            a = 4'b1010;
            b = 4'b0101;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=5, b=10", test_num);
            a = 4'b0101;
            b = 4'b1010;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=13, b=12", test_num);
            a = 4'b1101;
            b = 4'b1100;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_eq;
        input expected_gt_a;
        input expected_gt_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_gt_a === (expected_gt_a ^ gt_a ^ expected_gt_a) &&
                expected_gt_b === (expected_gt_b ^ gt_b ^ expected_gt_b)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, gt_a=%b, gt_b=%b",
                         eq, gt_a, gt_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, gt_a=%b, gt_b=%b",
                         expected_eq, expected_gt_a, expected_gt_b);
                $display("  Got:      eq=%b, gt_a=%b, gt_b=%b",
                         eq, gt_a, gt_b);
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
