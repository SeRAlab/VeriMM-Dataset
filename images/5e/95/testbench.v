`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg BI;
    reg CI;
    wire CO;
    wire [31:0] X;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .BI(BI),
        .CI(CI),
        .CO(CO),
        .X(X),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (A+B)", test_num);
            A = 32'd15;
            B = 32'd25;
            CI = 1'b0;
            BI = 1'b0;

            #1;


            check_outputs(1'b0, 32'h00000016, 32'h00000028);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Carry-In (A+B+CI)", test_num);
            A = 32'd100;
            B = 32'd50;
            CI = 1'b1;
            BI = 1'b0;

            #1;


            check_outputs(1'b0, 32'h00000056, 32'h00000097);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (A-B)", test_num);
            A = 32'd100;
            B = 32'd40;
            CI = 1'b1;
            BI = 1'b1;


            #1;



            check_outputs(1'b1, 32'h0000004C, 32'h0000003C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction resulting in Negative (20-50)", test_num);
            A = 32'd20;
            B = 32'd50;
            CI = 1'b1;
            BI = 1'b1;


            #1;



            check_outputs(1'b0, 32'h00000026, 32'hFFFFFFE2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Carry-Out", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            CI = 1'b0;
            BI = 1'b0;

            #1;


            check_outputs(1'b1, 32'hFFFFFFFE, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise XOR and Max Positive Sum", test_num);
            A = 32'h7FFFFFFF;
            B = 32'h00000001;
            CI = 1'b0;
            BI = 1'b0;

            #1;


            check_outputs(1'b0, 32'h7FFFFFFE, 32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction of Zero (A-0)", test_num);
            A = 32'h12345678;
            B = 32'h00000000;
            CI = 1'b1;
            BI = 1'b1;

            #1;


            check_outputs(1'b1, 32'h12345678, 32'h12345678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input", test_num);
            A = 32'h00000000;
            B = 32'h00000000;
            CI = 1'b0;
            BI = 1'b0;

            #1;


            check_outputs(1'b0, 32'h00000000, 32'h00000000);
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
        input expected_CO;
        input [31:0] expected_X;
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_X === (expected_X ^ X ^ expected_X) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, X=%h, Y=%h",
                         CO, X, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, X=%h, Y=%h",
                         expected_CO, expected_X, expected_Y);
                $display("  Got:      CO=%b, X=%h, Y=%h",
                         CO, X, Y);
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
