`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [6:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .d(d)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            a = 4'b0000;
            b = 4'b0000;
            #1;

            check_outputs(calculate_expected(a, b));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            a = 4'b1111;
            b = 4'b1111;
            #1;

            check_outputs(calculate_expected(a, b));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Lower Bits Max (3x3)", test_num);
            a = 4'b0011;
            b = 4'b0011;
            #1;

            check_outputs(calculate_expected(a, b));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Upper Bits Max (3x3)", test_num);
            a = 4'b1100;
            b = 4'b1100;
            #1;

            check_outputs(calculate_expected(a, b));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum XOR Difference (1010 vs 0101)", test_num);
            a = 4'b1010;
            b = 4'b0101;
            #1;

            check_outputs(calculate_expected(a, b));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed Input Pattern A", test_num);
            a = 4'b0111;
            b = 4'b1011;
            #1;

            check_outputs(calculate_expected(a, b));
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed Input Pattern B", test_num);
            a = 4'b1101;
            b = 4'b0110;
            #1;

            check_outputs(calculate_expected(a, b));
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max A, Zero B", test_num);
            a = 4'b1111;
            b = 4'b0000;
            #1;

            check_outputs(calculate_expected(a, b));
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
        input [6:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: d=%h",
                         d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h",
                         expected_d);
                $display("  Got:      d=%h",
                         d);
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
