`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire eq;
    wire ge8;
    wire lt8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .eq(eq),
        .ge8(ge8),
        .lt8(lt8)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=0, b=0 (Equality)", test_num);
            a = 4'd0;
            b = 4'd0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=10, b=10 (Equality)", test_num);
            a = 4'd10;
            b = 4'd10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=5, b=4 (Diff=1)", test_num);
            a = 4'd5;
            b = 4'd4;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=4, b=5 (Diff=1)", test_num);
            a = 4'd4;
            b = 4'd5;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=10, b=3 (Diff=7)", test_num);
            a = 4'd10;
            b = 4'd3;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=10, b=2 (Diff=8)", test_num);
            a = 4'd10;
            b = 4'd2;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=2, b=9 (Diff=7)", test_num);
            a = 4'd2;
            b = 4'd9;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=2, b=10 (Diff=8)", test_num);
            a = 4'd2;
            b = 4'd10;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=15, b=0 (Diff=15)", test_num);
            a = 4'd15;
            b = 4'd0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=0, b=15 (Diff=15)", test_num);
            a = 4'd0;
            b = 4'd15;

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
        input expected_ge8;
        input expected_lt8;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_ge8 === (expected_ge8 ^ ge8 ^ expected_ge8) &&
                expected_lt8 === (expected_lt8 ^ lt8 ^ expected_lt8)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, ge8=%b, lt8=%b",
                         eq, ge8, lt8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, ge8=%b, lt8=%b",
                         expected_eq, expected_ge8, expected_lt8);
                $display("  Got:      eq=%b, ge8=%b, lt8=%b",
                         eq, ge8, lt8);
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
