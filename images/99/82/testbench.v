`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire Cout;
    wire [3:0] Sum;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum),
        .V(V)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'h1; B = 4'h2; Cin = 0;
            #1;

            check_outputs(1'b0, 4'h3, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'h3; B = 4'h4; Cin = 1;
            #1;

            check_outputs(1'b0, 4'h8, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'hF; B = 4'h1; Cin = 0;
            #1;

            check_outputs(1'b1, 4'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'h7; B = 4'h1; Cin = 0;
            #1;

            check_outputs(1'b0, 4'h8, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'h8; B = 4'h8; Cin = 0;
            #1;

            check_outputs(1'b1, 4'h0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'hF; B = 4'hF; Cin = 1;
            #1;

            check_outputs(1'b1, 4'hF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'h0; B = 4'h0; Cin = 0;
            #1;

            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'h8; B = 4'h1; Cin = 0;
            #1;

            check_outputs(1'b0, 4'h9, 1'b0);
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
        input expected_Cout;
        input [3:0] expected_Sum;
        input expected_V;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h, V=%b",
                         Cout, Sum, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h, V=%b",
                         expected_Cout, expected_Sum, expected_V);
                $display("  Got:      Cout=%b, Sum=%h, V=%b",
                         Cout, Sum, V);
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
