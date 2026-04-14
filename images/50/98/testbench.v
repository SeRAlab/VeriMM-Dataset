`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg [1:0] opcode;
    reg reset;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .opcode(opcode),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            opcode = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 8'd45;
            b = 8'd20;
            opcode = 2'b00;
            @(posedge clk);
            #2;
            $display("Test %0d: Addition (45 + 20)", test_num);
            #1;

            check_outputs(8'd65);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 8'd100;
            b = 8'd30;
            opcode = 2'b01;
            @(posedge clk);
            #2;
            $display("Test %0d: Subtraction (100 - 30)", test_num);
            #1;

            check_outputs(8'd70);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 8'd12;
            b = 8'd10;
            opcode = 2'b10;
            @(posedge clk);
            #2;
            $display("Test %0d: Multiplication (12 * 10)", test_num);
            #1;

            check_outputs(8'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 8'd80;
            b = 8'd4;
            opcode = 2'b11;
            @(posedge clk);
            #2;
            $display("Test %0d: Division (80 / 4)", test_num);
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 8'd200;
            b = 8'd100;
            opcode = 2'b00;
            @(posedge clk);
            #2;
            $display("Test %0d: Addition Overflow (200 + 100)", test_num);
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 8'd10;
            b = 8'd20;
            opcode = 2'b01;
            @(posedge clk);
            #2;
            $display("Test %0d: Subtraction Underflow (10 - 20)", test_num);
            #1;

            check_outputs(8'd246);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = 8'd64;
            b = 8'd4;
            opcode = 2'b10;
            @(posedge clk);
            #2;
            $display("Test %0d: Multiplication Truncation (64 * 4)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            a = 8'd10;
            b = 8'd3;
            opcode = 2'b11;
            @(posedge clk);
            #2;
            $display("Test %0d: Integer Division (10 / 3)", test_num);
            #1;

            check_outputs(8'd3);
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
        input [7:0] expected_result;
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
        $dumpvars(0,a, b, clk, opcode, reset, result);
    end

endmodule
