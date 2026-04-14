`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Cin;
    reg [3:0] in1;
    reg [3:0] in2;
    wire Cout;
    wire [3:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cin(Cin),
        .in1(in1),
        .in2(in2),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (2 + 3, Cin=0)", test_num);
            in1 = 4'd2; in2 = 4'd3; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Cin (5 + 5, Cin=1)", test_num);
            in1 = 4'd5; in2 = 4'd5; Cin = 1'b1;
            #1;

            check_outputs(1'b0, 4'd11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Sum No Cout (7 + 8, Cin=0)", test_num);
            in1 = 4'd7; in2 = 4'd8; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Cout (8 + 8, Cin=0)", test_num);
            in1 = 4'd8; in2 = 4'd8; Cin = 1'b0;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Propagation (15 + 0, Cin=1)", test_num);
            in1 = 4'hf; in2 = 4'h0; Cin = 1'b1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Inputs (15 + 15, Cin=1)", test_num);
            in1 = 4'hf; in2 = 4'hf; Cin = 1'b1;
            #1;

            check_outputs(1'b1, 4'hf);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs (0 + 0, Cin=0)", test_num);
            in1 = 4'd0; in2 = 4'd0; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (10 + 5, Cin=0)", test_num);
            in1 = 4'b1010; in2 = 4'b0101; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Overflow (12 + 4, Cin=0)", test_num);
            in1 = 4'd12; in2 = 4'd4; Cin = 1'b0;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of Two Overflow (9 + 6, Cin=1)", test_num);
            in1 = 4'd9; in2 = 4'd6; Cin = 1'b1;
            #1;

            check_outputs(1'b1, 4'd0);
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
        input expected_Cout;
        input [3:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%h",
                         Cout, Sum);
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
