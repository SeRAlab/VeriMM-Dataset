`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire EQ;
    wire GT;
    wire LT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .EQ(EQ),
        .GT(GT),
        .LT(LT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 32'sd0;
            B = 32'sd0;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 32'sd12345678;
            B = 32'sd12345678;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = -32'sd9876543;
            B = -32'sd9876543;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 32'sd1000;
            B = 32'sd500;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 32'sd500;
            B = 32'sd1000;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = -32'sd10;
            B = -32'sd20;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = -32'sd50;
            B = -32'sd30;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 32'sd1;
            B = -32'sd1;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = -32'sd5000;
            B = 32'sd1;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 32'sh7FFFFFFF;
            B = 32'sd0;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            A = 32'sh80000000;
            B = 32'sd0;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            A = 32'sh7FFFFFFF;
            B = 32'sh80000000;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            A = 32'sh80000000;
            B = 32'sh7FFFFFFF;
            $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
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
        testcase013();
        
        
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
        input expected_EQ;
        input expected_GT;
        input expected_LT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EQ === (expected_EQ ^ EQ ^ expected_EQ) &&
                expected_GT === (expected_GT ^ GT ^ expected_GT) &&
                expected_LT === (expected_LT ^ LT ^ expected_LT)) begin
                $display("PASS");
                $display("  Outputs: EQ=%b, GT=%b, LT=%b",
                         EQ, GT, LT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ=%b, GT=%b, LT=%b",
                         expected_EQ, expected_GT, expected_LT);
                $display("  Got:      EQ=%b, GT=%b, LT=%b",
                         EQ, GT, LT);
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
