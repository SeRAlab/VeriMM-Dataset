`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] Diff;
    wire [7:0] Prod;
    wire [7:0] Quot;
    wire [7:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Diff(Diff),
        .Prod(Prod),
        .Quot(Quot),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=10, B=5", test_num);
            A = 8'd10;
            B = 8'd5;

            #1;


            check_outputs(8'h05, 8'h32, 8'h02, 8'h0F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=20, B=0 (Division by Zero)", test_num);
            A = 8'd20;
            B = 8'd0;

            #1;


            check_outputs(8'h14, 8'h00, 8'hFF, 8'h14);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=255, B=2 (Overflow check)", test_num);
            A = 8'd255;
            B = 8'd2;

            #1;


            check_outputs(8'hFD, 8'hFE, 8'h7F, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=5, B=10 (Underflow check)", test_num);
            A = 8'd5;
            B = 8'd10;

            #1;


            check_outputs(8'hFB, 8'h32, 8'h00, 8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=255, B=255", test_num);
            A = 8'd255;
            B = 8'd255;

            #1;


            check_outputs(8'h00, 8'h01, 8'h01, 8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0, B=0", test_num);
            A = 8'd0;
            B = 8'd0;

            #1;


            check_outputs(8'h00, 8'h00, 8'hFF, 8'h00);
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
        input [7:0] expected_Diff;
        input [7:0] expected_Prod;
        input [7:0] expected_Quot;
        input [7:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Diff === (expected_Diff ^ Diff ^ expected_Diff) &&
                expected_Prod === (expected_Prod ^ Prod ^ expected_Prod) &&
                expected_Quot === (expected_Quot ^ Quot ^ expected_Quot) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Diff=%h, Prod=%h, Quot=%h, Sum=%h",
                         Diff, Prod, Quot, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Diff=%h, Prod=%h, Quot=%h, Sum=%h",
                         expected_Diff, expected_Prod, expected_Quot, expected_Sum);
                $display("  Got:      Diff=%h, Prod=%h, Quot=%h, Sum=%h",
                         Diff, Prod, Quot, Sum);
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
