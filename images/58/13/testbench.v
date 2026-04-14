`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [1:0] Op;
    reg RST;
    wire Overflow;
    wire [7:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Op(Op),
        .RST(RST),
        .Overflow(Overflow),
        .Result(Result)
    );
    task testcase001;

    begin
        test_num = 1;

        RST = 1; A = 4'd5; B = 4'd3; Op = 2'b00; #10;

        RST = 0; #10;
        $display("Test %0d: Addition (5 + 3)", test_num);
        #1;

        check_outputs(1'b0, 8'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        RST = 1; A = 4'd10; B = 4'd4; Op = 2'b01; #10;
        RST = 0; #10;
        $display("Test %0d: Subtraction (10 - 4)", test_num);
        #1;

        check_outputs(1'b0, 8'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        RST = 1; A = 4'd3; B = 4'd4; Op = 2'b10; #10;
        RST = 0; #10;
        $display("Test %0d: Multiplication (3 * 4)", test_num);
        #1;

        check_outputs(1'b0, 8'd12);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        RST = 1; A = 4'd12; B = 4'd3; Op = 2'b11; #10;
        RST = 0; #10;
        $display("Test %0d: Division (12 / 3)", test_num);
        #1;

        check_outputs(1'b0, 8'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        RST = 1; A = 4'd15; B = 4'd15; Op = 2'b00; #10;
        RST = 0; #10;
        $display("Test %0d: Max Addition (15 + 15)", test_num);
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        RST = 1; A = 4'd15; B = 4'd15; Op = 2'b10; #10;
        RST = 0; #10;
        $display("Test %0d: Max Multiplication (15 * 15)", test_num);
        #1;

        check_outputs(1'b0, 8'd225);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        RST = 1; A = 4'd10; B = 4'd0; Op = 2'b11; #10;
        RST = 0; #10;
        $display("Test %0d: Division by Zero", test_num);

        #1;


        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        RST = 1; A = 4'd7; B = 4'd7; Op = 2'b01; #10;
        RST = 0; #10;
        $display("Test %0d: Subtraction resulting in Zero", test_num);
        #1;

        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        RST = 1; A = 4'd15; B = 4'd15; Op = 2'b10; #10;

        $display("Test %0d: Reset Persistence Check", test_num);
        #1;

        check_outputs(1'b0, 8'd0);
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
        input expected_Overflow;
        input [7:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Overflow === (expected_Overflow ^ Overflow ^ expected_Overflow) &&
                expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Overflow=%b, Result=%h",
                         Overflow, Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Overflow=%b, Result=%h",
                         expected_Overflow, expected_Result);
                $display("  Got:      Overflow=%b, Result=%h",
                         Overflow, Result);
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
