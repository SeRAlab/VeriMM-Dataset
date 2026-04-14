`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg unsigned_cmp;
    wire equal;
    wire greater;
    wire less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .unsigned_cmp(unsigned_cmp),
        .equal(equal),
        .greater(greater),
        .less(less)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned Equality (Zero)", test_num);
            unsigned_cmp = 1;
            a = 32'h00000000;
            b = 32'h00000000;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned a > b (Positive)", test_num);
            unsigned_cmp = 1;
            a = 32'd100;
            b = 32'd50;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned a < b (Positive)", test_num);
            unsigned_cmp = 1;
            a = 32'd25;
            b = 32'd75;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned Comparison with High Bit Set", test_num);
            unsigned_cmp = 1;
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Equality (Negative)", test_num);
            unsigned_cmp = 0;
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Positive comparison", test_num);
            unsigned_cmp = 0;
            a = 32'd10;
            b = 32'd20;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Negative comparison (-1 > -2)", test_num);
            unsigned_cmp = 0;
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFE;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Pos vs Neg (1 > -1)", test_num);
            unsigned_cmp = 0;
            a = 32'h00000001;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Neg vs Pos (-100 < 10)", test_num);
            unsigned_cmp = 0;
            a = 32'hFFFFFF9C;
            b = 32'h0000000A;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Extreme (Max Pos vs Min Neg)", test_num);
            unsigned_cmp = 0;
            a = 32'h7FFFFFFF;
            b = 32'h80000000;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned Extreme (Max Pos vs Min Neg bits)", test_num);
            unsigned_cmp = 1;
            a = 32'h7FFFFFFF;
            b = 32'h80000000;
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
        input expected_equal;
        input expected_greater;
        input expected_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater === (expected_greater ^ greater ^ expected_greater) &&
                expected_less === (expected_less ^ less ^ expected_less)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, greater=%b, less=%b",
                         equal, greater, less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, greater=%b, less=%b",
                         expected_equal, expected_greater, expected_less);
                $display("  Got:      equal=%b, greater=%b, less=%b",
                         equal, greater, less);
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
