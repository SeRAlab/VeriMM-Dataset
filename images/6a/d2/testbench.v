`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire V;
    wire [1:0] Y;
    wire equal;
    wire greater;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .V(V),
        .Y(Y),
        .equal(equal),
        .greater(greater),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=1000, B=0001 (A > B, High Priority)", test_num);
            A = 4'b1000; B = 4'b0001;

            #1;


            check_outputs(1'b1, 2'b11, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0100, B=0100 (A == B, Med-High Priority)", test_num);
            A = 4'b0100; B = 4'b0100;

            #1;


            check_outputs(1'b1, 2'b10, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0010, B=1010 (A < B, Med-Low Priority)", test_num);
            A = 4'b0010; B = 4'b1010;

            #1;


            check_outputs(1'b1, 2'b01, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0001, B=0000 (A > B, Lowest Priority bit set)", test_num);
            A = 4'b0001; B = 4'b0000;

            #1;


            check_outputs(1'b1, 2'b00, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0000, B=0000 (A == B, All zero input)", test_num);
            A = 4'b0000; B = 4'b0000;

            #1;


            check_outputs(1'b0, 2'b00, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=1111, B=0000 (A > B, All bits set)", test_num);
            A = 4'b1111; B = 4'b0000;

            #1;


            check_outputs(1'b1, 2'b11, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0011, B=0100 (A < B, Multiple bits set)", test_num);
            A = 4'b0011; B = 4'b0100;

            #1;


            check_outputs(1'b1, 2'b01, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=1010, B=1010 (A == B, Highest bit set)", test_num);
            A = 4'b1010; B = 4'b1010;

            #1;


            check_outputs(1'b1, 2'b11, 1'b1, 1'b0, 1'b1);
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
        input expected_V;
        input [1:0] expected_Y;
        input expected_equal;
        input expected_greater;
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V === (expected_V ^ V ^ expected_V) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater === (expected_greater ^ greater ^ expected_greater) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: V=%b, Y=%h, equal=%b, greater=%b, result=%b",
                         V, Y, equal, greater, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V=%b, Y=%h, equal=%b, greater=%b, result=%b",
                         expected_V, expected_Y, expected_equal, expected_greater, expected_result);
                $display("  Got:      V=%b, Y=%h, equal=%b, greater=%b, result=%b",
                         V, Y, equal, greater, result);
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
