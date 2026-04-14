`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cmp_mode;
    reg [7:0] num1;
    reg [7:0] num2;
    wire eq;
    wire gt;
    wire lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cmp_mode(cmp_mode),
        .num1(num1),
        .num2(num2),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Unsigned Equality (10 == 10)", test_num);
        cmp_mode = 0; num1 = 8'd10; num2 = 8'd10;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Unsigned GT (255 > 128)", test_num);
        cmp_mode = 0; num1 = 8'd255; num2 = 8'd128;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Unsigned LT (5 < 20)", test_num);
        cmp_mode = 0; num1 = 8'd5; num2 = 8'd20;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Signed Equality (positive)", test_num);
        cmp_mode = 1; num1 = 8'd64; num2 = 8'd64;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Signed Equality (negative: -1 == -1)", test_num);
        cmp_mode = 1; num1 = 8'hFF; num2 = 8'hFF;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Signed GT (Positive > Negative: 1 > -1)", test_num);
        cmp_mode = 1; num1 = 8'd1; num2 = 8'hFF;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Unsigned LT (Comparing same bits as T6: 1 < 255)", test_num);
        cmp_mode = 0; num1 = 8'h01; num2 = 8'hFF;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Signed GT (Negative > Negative: -1 > -2)", test_num);
        cmp_mode = 1; num1 = 8'hFF; num2 = 8'hFE;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Signed LT (Negative < Positive: -128 < 127)", test_num);
        cmp_mode = 1; num1 = 8'h80; num2 = 8'h7F;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Signed LT (Negative < Negative: -128 < -1)", test_num);
        cmp_mode = 1; num1 = 8'h80; num2 = 8'hFF;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Unsigned GT (255 > 0)", test_num);
        cmp_mode = 0; num1 = 8'hFF; num2 = 8'h00;
        #1;

        check_outputs(0, 1, 0);
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
