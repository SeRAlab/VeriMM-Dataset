`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg [2:0] opcode;
    wire [3:0] out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .opcode(opcode),
        .out(out),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            opcode = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 4'h3; B = 4'h4; opcode = OP_ADD;
            @(posedge clk);
            #1;
            $display("Test 001: Addition (3+4)");
            #1;

            check_outputs(4'h7, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 4'hA; B = 4'hA; opcode = OP_SUB;
            @(posedge clk);
            #1;
            $display("Test 002: Subtraction (10-10)");
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 4'b1100; B = 4'b1010; opcode = OP_AND;
            @(posedge clk);
            #1;
            $display("Test 003: Bitwise AND");
            #1;

            check_outputs(4'b1000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 4'b1100; B = 4'b0011; opcode = OP_OR;
            @(posedge clk);
            #1;
            $display("Test 004: Bitwise OR");
            #1;

            check_outputs(4'b1111, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 4'b1010; B = 4'b1111; opcode = OP_XOR;
            @(posedge clk);
            #1;
            $display("Test 005: Bitwise XOR");
            #1;

            check_outputs(4'b0101, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 4'b0011; B = 4'h0; opcode = OP_SLL;
            @(posedge clk);
            #1;
            $display("Test 006: Shift Left");
            #1;

            check_outputs(4'b0110, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 4'b1000; B = 4'h0; opcode = OP_SRL;
            @(posedge clk);
            #1;
            $display("Test 007: Shift Right");
            #1;

            check_outputs(4'b0100, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 4'b1010; B = 4'h0; opcode = OP_NOT;
            @(posedge clk);
            #1;
            $display("Test 008: Bitwise NOT");
            #1;

            check_outputs(4'b0101, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            A = 4'hF; B = 4'h1; opcode = OP_ADD;
            @(posedge clk);
            #1;
            $display("Test 009: Addition Wrap-around (15+1)");
            #1;

            check_outputs(4'h0, 1'b1);
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
        input [3:0] expected_out;
        input expected_zero;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: out=%h, zero=%b",
                         out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, zero=%b",
                         expected_out, expected_zero);
                $display("  Got:      out=%h, zero=%b",
                         out, zero);
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
        $dumpvars(0,A, B, clk, opcode, out, zero);
    end

endmodule
