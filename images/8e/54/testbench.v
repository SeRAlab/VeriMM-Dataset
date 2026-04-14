`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] OP;
    reg clk;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .OP(OP),
        .clk(clk),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'd0;
            B = 4'd0;
            OP = 3'b111;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Addition (3 + 4)", test_num);
            A = 4'd3;
            B = 4'd4;
            OP = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Subtraction (10 - 3)", test_num);
            A = 4'd10;
            B = 4'd3;
            OP = 3'b001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Bitwise AND (1010 & 1100)", test_num);
            A = 4'b1010;
            B = 4'b1100;
            OP = 3'b010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Bitwise OR (1010 | 0101)", test_num);
            A = 4'b1010;
            B = 4'b0101;
            OP = 3'b011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Bitwise XOR (1100 ^ 1010)", test_num);
            A = 4'b1100;
            B = 4'b1010;
            OP = 3'b100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Arithmetic Left Shift (0011 << 1)", test_num);
            A = 4'b0011;
            B = 4'd1;
            OP = 3'b101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Default Case (OP 110)", test_num);
            A = 4'hF;
            B = 4'hF;
            OP = 3'b110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Addition Overflow (15 + 1)", test_num);
            A = 4'd15;
            B = 4'd1;
            OP = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Test %0d: Subtraction Underflow (0 - 1)", test_num);
            A = 4'd0;
            B = 4'd1;
            OP = 3'b001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
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
        input [3:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,A, B, OP, clk, result);
    end

endmodule
