`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg Sel;
    wire Cout;
    wire [3:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sel(Sel),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unsigned Addition (Sel=0, A=1, B=2, Cin=0)", test_num);
            A = 4'd1; B = 4'd2; Cin = 1'b0; Sel = 1'b0;
            #1;

            check_outputs(1'b0, 4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unsigned Addition - Carry Out (Sel=0, A=8, B=8, Cin=0)", test_num);
            A = 4'd8; B = 4'd8; Cin = 1'b0; Sel = 1'b0;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unsigned Addition - Max (Sel=0, A=15, B=15, Cin=1)", test_num);
            A = 4'hF; B = 4'hF; Cin = 1'b1; Sel = 1'b0;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction/2's Comp - Pos (Sel=1, A=10, B=4)", test_num);
            A = 4'd10; B = 4'd4; Cin = 1'b0; Sel = 1'b1;

            #1;


            check_outputs(1'b1, 4'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction/2's Comp - Neg (Sel=1, A=4, B=10)", test_num);
            A = 4'd4; B = 4'd10; Cin = 1'b0; Sel = 1'b1;

            #1;


            check_outputs(1'b0, 4'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction/2's Comp - Zero (Sel=1, A=7, B=7)", test_num);
            A = 4'd7; B = 4'd7; Cin = 1'b1; Sel = 1'b1;

            #1;


            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Zero (Sel=0, A=0, B=0, Cin=0)", test_num);
            A = 4'd0; B = 4'd0; Cin = 1'b0; Sel = 1'b0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Zero (Sel=1, A=0, B=0)", test_num);
            A = 4'd0; B = 4'd0; Cin = 1'b0; Sel = 1'b1;

            #1;


            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Large Neg (Sel=1, A=0, B=15)", test_num);
            A = 4'd0; B = 4'd15; Cin = 1'b0; Sel = 1'b1;

            #1;


            check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Mixed (Sel=0, A=10, B=10, Cin=0)", test_num);
            A = 4'd10; B = 4'd10; Cin = 1'b0; Sel = 1'b0;

            #1;


            check_outputs(1'b1, 4'd4);
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
