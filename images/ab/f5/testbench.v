`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg CLK;
    reg RST;
    reg Subtract;
    wire Overflow;
    wire [31:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .RST(RST),
        .Subtract(Subtract),
        .Overflow(Overflow),
        .Result(Result)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            A = 0;
            B = 0;
            Subtract = 0;
            @(posedge CLK);
            #2;
            RST = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 32'd100;
            B = 32'd200;
            Subtract = 0;
            @(posedge CLK);
            #2;
            $display("Test %0d: Simple Addition (100 + 200)", test_num);
            #1;

            check_outputs(1'b0, 32'd300);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 32'd500;
            B = 32'd150;
            Subtract = 1;
            @(posedge CLK);
            #2;
            $display("Test %0d: Simple Subtraction (500 - 150)", test_num);
            #1;

            check_outputs(1'b0, 32'd350);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 32'h7FFFFFFF;
            B = 32'h00000001;
            Subtract = 0;
            @(posedge CLK);
            #2;
            $display("Test %0d: Addition Overflow (MaxPos + 1)", test_num);
            #1;

            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 32'h80000000;
            B = 32'hFFFFFFFF;
            Subtract = 0;
            @(posedge CLK);
            #2;
            $display("Test %0d: Addition Overflow (MinNeg + -1)", test_num);
            #1;

            check_outputs(1'b1, 32'h7FFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 32'h7FFFFFFF;
            B = 32'hFFFFFFFF;
            Subtract = 1;
            @(posedge CLK);
            #2;
            $display("Test %0d: Subtraction Overflow (MaxPos - -1)", test_num);
            #1;

            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 32'h80000000;
            B = 32'h00000001;
            Subtract = 1;
            @(posedge CLK);
            #2;
            $display("Test %0d: Subtraction Overflow (MinNeg - 1)", test_num);
            #1;

            check_outputs(1'b1, 32'h7FFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 32'hDEADBEEF;
            B = 32'hDEADBEEF;
            Subtract = 1;
            @(posedge CLK);
            #2;
            $display("Test %0d: Identity (A - A = 0)", test_num);
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 32'h10000000;
            B = 32'hF0000000;
            Subtract = 0;
            @(posedge CLK);
            #2;
            $display("Test %0d: Addition (Pos + Neg, No Overflow)", test_num);
            #1;

            check_outputs(1'b0, 32'h00000000);
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
        input expected_Overflow;
        input [31:0] expected_Result;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, CLK, RST, Subtract, Overflow, Result);
    end

endmodule
