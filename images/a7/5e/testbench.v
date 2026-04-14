`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] num1;
    reg [31:0] num2;
    reg sel;
    wire eq;
    wire gt;
    wire lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num1(num1),
        .num2(num2),
        .sel(sel),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unsigned Equality", test_num);
            num1 = 32'hA5A5A5A5;
            num2 = 32'hA5A5A5A5;
            sel  = 0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unsigned Greater Than", test_num);
            num1 = 32'hFFFFFFFF;
            num2 = 32'h00000001;
            sel  = 0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unsigned Less Than", test_num);
            num1 = 32'h0000000A;
            num2 = 32'h0000000B;
            sel  = 0;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signed Equality (Positive)", test_num);
            num1 = 32'd12345678;
            num2 = 32'd12345678;
            sel  = 1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signed Equality (Negative)", test_num);
            num1 = 32'hFFFFFFFF;
            num2 = 32'hFFFFFFFF;
            sel  = 1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signed Positive > Negative", test_num);
            num1 = 32'd1;
            num2 = 32'hFFFFFFFF;
            sel  = 1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signed Negative < Positive", test_num);
            num1 = 32'h80000000;
            num2 = 32'h00000000;
            sel  = 1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signed Negative > Negative", test_num);
            num1 = 32'hFFFFFFFF;
            num2 = 32'hFFFFFFFE;
            sel  = 1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signed Boundary (Max Pos > Max Neg)", test_num);
            num1 = 32'h7FFFFFFF;
            num2 = 32'h80000000;
            sel  = 1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unsigned Boundary (MSB comparison)", test_num);
            num1 = 32'h7FFFFFFF;
            num2 = 32'h80000000;
            sel  = 0;
            #1;

            check_outputs(0, 0, 1);
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
        input expected_eq;
        input expected_gt;
        input expected_lt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt) &&
                expected_lt === (expected_lt ^ lt ^ expected_lt)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, gt=%b, lt=%b",
                         eq, gt, lt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, gt=%b, lt=%b",
                         expected_eq, expected_gt, expected_lt);
                $display("  Got:      eq=%b, gt=%b, lt=%b",
                         eq, gt, lt);
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
