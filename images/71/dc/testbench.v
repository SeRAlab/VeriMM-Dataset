`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg S;
    wire V;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S(S),
        .V(V),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition - No Overflow (Positive Result)", test_num);
            A = 4'd2;
            B = 4'd3;
            S = 1'b0;

            #1;


            check_outputs(1'b0, 4'b0101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition - No Overflow (Negative Result)", test_num);
            A = 4'b1110;
            B = 4'b1101;
            S = 1'b0;

            #1;


            check_outputs(1'b0, 4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition - Positive Overflow (7 + 1)", test_num);
            A = 4'b0111;
            B = 4'b0001;
            S = 1'b0;

            #1;


            check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition - Negative Overflow (-7 + -2)", test_num);
            A = 4'b1001;
            B = 4'b1110;
            S = 1'b0;

            #1;


            check_outputs(1'b1, 4'b0111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction - No Overflow (Positive Result)", test_num);
            A = 4'd5;
            B = 4'd2;
            S = 1'b1;

            #1;


            check_outputs(1'b0, 4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction - No Overflow (Negative Result)", test_num);
            A = 4'd2;
            B = 4'd5;
            S = 1'b1;

            #1;


            check_outputs(1'b0, 4'b1101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction - Positive Overflow (7 - (-1))", test_num);
            A = 4'b0111;
            B = 4'b1111;
            S = 1'b1;

            #1;


            check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction - Negative Overflow (-8 - 1)", test_num);
            A = 4'b1000;
            B = 4'b0001;
            S = 1'b1;

            #1;


            check_outputs(1'b1, 4'b0111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Case - Zero Result (Subtraction)", test_num);
            A = 4'b1010;
            B = 4'b1010;
            S = 1'b1;

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Case - Max Negative plus 0", test_num);
            A = 4'b1000;
            B = 4'b0000;
            S = 1'b0;

            #1;


            check_outputs(1'b0, 4'b1000);
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
        input expected_V;
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V === (expected_V ^ V ^ expected_V) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: V=%b, Y=%h",
                         V, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V=%b, Y=%h",
                         expected_V, expected_Y);
                $display("  Got:      V=%b, Y=%h",
                         V, Y);
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
