`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg sub;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sub(sub),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (1 + 1)", test_num);
            a = 32'h00000001;
            b = 32'h00000001;
            sub = 1'b0;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Subtraction (10 - 5)", test_num);
            a = 32'd10;
            b = 32'd5;
            sub = 1'b1;
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Carry across 4-bit CLA groups", test_num);
            a = 32'h0000000F;
            b = 32'h00000001;
            sub = 1'b0;
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction crossing 4-bit CLA groups", test_num);
            a = 32'h00000010;
            b = 32'h00000001;
            sub = 1'b1;
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Addition (Max across blocks)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            sub = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Subtraction (Result -1)", test_num);
            a = 32'h00000000;
            b = 32'h00000001;
            sub = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction of same number", test_num);
            a = 32'hABCDE123;
            b = 32'hABCDE123;
            sub = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Adding zero", test_num);
            a = 32'h12345678;
            b = 32'h00000000;
            sub = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction of negative equivalent", test_num);

            a = 32'h00000000;
            b = 32'hFFFFFFFF;
            sub = 1'b1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complex Bit Pattern Addition", test_num);
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            sub = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
