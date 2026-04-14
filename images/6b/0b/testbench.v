`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] X;
    reg [3:0] Y;
    wire greater_than_or_equal_to_5;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X(X),
        .Y(Y),
        .greater_than_or_equal_to_5(greater_than_or_equal_to_5),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            X = 4'b0000;
            Y = 4'b0000;

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            X = 4'b1111;
            Y = 4'b1111;

            #1;


            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Below 5 (Result=4)", test_num);
            X = 4'b1100;
            Y = 4'b0110;

            #1;


            check_outputs(1'b0, 4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary At 5 (Result=5)", test_num);
            X = 4'b0111;
            Y = 4'b1101;

            #1;


            check_outputs(1'b1, 4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Masking (Result=0)", test_num);
            X = 4'b1010;
            Y = 4'b0101;

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Bit Check (Result=8)", test_num);
            X = 4'b1000;
            Y = 4'b1000;

            #1;


            check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Value Check (Result=1)", test_num);
            X = 4'b0011;
            Y = 4'b0101;

            #1;


            check_outputs(1'b0, 4'b0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex AND (Result=6)", test_num);
            X = 4'b1110;
            Y = 4'b0110;

            #1;


            check_outputs(1'b1, 4'b0110);
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
        input expected_greater_than_or_equal_to_5;
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_greater_than_or_equal_to_5 === (expected_greater_than_or_equal_to_5 ^ greater_than_or_equal_to_5 ^ expected_greater_than_or_equal_to_5) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: greater_than_or_equal_to_5=%b, result=%h",
                         greater_than_or_equal_to_5, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: greater_than_or_equal_to_5=%b, result=%h",
                         expected_greater_than_or_equal_to_5, expected_result);
                $display("  Got:      greater_than_or_equal_to_5=%b, result=%h",
                         greater_than_or_equal_to_5, result);
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
