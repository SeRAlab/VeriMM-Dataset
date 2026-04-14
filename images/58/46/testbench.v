`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg S;
    wire Cout;
    wire [3:0] Difference;
    wire [3:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S(S),
        .Cout(Cout),
        .Difference(Difference),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd5; B = 4'd3; S = 1'b0;

        #1;


        check_outputs(1'b0, 4'd2, 4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd12; B = 4'd5; S = 1'b0;

        #1;


        check_outputs(1'b1, 4'd7, 4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd10; B = 4'd4; S = 1'b1;

        #1;


        check_outputs(1'b0, 4'd6, 4'd14);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd7; B = 4'd7; S = 1'b1;

        #1;


        check_outputs(1'b0, 4'd0, 4'd14);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd3; B = 4'd5; S = 1'b1;


        #1;



        check_outputs(1'b0, 4'd14, 4'd8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'hF; B = 4'hF; S = 1'b0;

        #1;


        check_outputs(1'b1, 4'd0, 4'd14);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd0; B = 4'd1; S = 1'b1;


        #1;



        check_outputs(1'b0, 4'd15, 4'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd0; B = 4'd0; S = 1'b0;

        #1;


        check_outputs(1'b0, 4'd0, 4'd0);
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
        input [3:0] expected_Difference;
        input [3:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Difference === (expected_Difference ^ Difference ^ expected_Difference) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Difference=%h, Sum=%h",
                         Cout, Difference, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Difference=%h, Sum=%h",
                         expected_Cout, expected_Difference, expected_Sum);
                $display("  Got:      Cout=%b, Difference=%h, Sum=%h",
                         Cout, Difference, Sum);
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
