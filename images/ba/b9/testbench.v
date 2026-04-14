`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg AddSub;
    reg [3:0] B;
    reg Cin;
    reg Clr;
    wire Cout;
    wire [3:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .AddSub(AddSub),
        .B(B),
        .Cin(Cin),
        .Clr(Clr),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Assert Clear", test_num);
        Clr = 1; A = 4'hA; B = 4'h5; Cin = 1; AddSub = 0;
        #1;

        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Addition (3 + 4 + 0)", test_num);
        Clr = 1; #5; Clr = 0;
        A = 4'd3; B = 4'd4; Cin = 0; AddSub = 0;
        #1;

        check_outputs(1'b0, 4'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition with Carry-out (10 + 10 + 0)", test_num);
        Clr = 1; #5; Clr = 0;
        A = 4'd10; B = 4'd10; Cin = 0; AddSub = 0;
        #1;

        check_outputs(1'b1, 4'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition with Carry-in (7 + 8 + 1)", test_num);
        Clr = 1; #5; Clr = 0;
        A = 4'd7; B = 4'd8; Cin = 1; AddSub = 0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Subtraction (10 - 3 - 0)", test_num);
        Clr = 1; #5; Clr = 0;
        A = 4'd10; B = 4'd3; Cin = 0; AddSub = 1;
        #1;

        check_outputs(1'b1, 4'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction with Borrow (10 - 3 - 1)", test_num);
        Clr = 1; #5; Clr = 0;
        A = 4'd10; B = 4'd3; Cin = 1; AddSub = 1;
        #1;

        check_outputs(1'b1, 4'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction Negative Result (4 - 10)", test_num);
        Clr = 1; #5; Clr = 0;
        A = 4'd4; B = 4'd10; Cin = 0; AddSub = 1;
        #1;

        check_outputs(1'b0, 4'd10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Addition (15 + 15 + 1)", test_num);
        Clr = 1; #5; Clr = 0;
        A = 4'hF; B = 4'hF; Cin = 1; AddSub = 0;
        #1;

        check_outputs(1'b1, 4'hF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction resulting in Zero (5 - 5)", test_num);
        Clr = 1; #5; Clr = 0;
        A = 4'd5; B = 4'd5; Cin = 0; AddSub = 1;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Toggle Clear during Subtraction", test_num);
        Clr = 0; A = 4'd15; B = 4'd0; Cin = 0; AddSub = 1;
        #2; Clr = 1;
        #1;

        check_outputs(1'b0, 4'd0);
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
