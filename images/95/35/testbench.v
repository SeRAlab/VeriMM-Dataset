`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg [2:0] op;
    wire carry;
    wire [7:0] out;
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
        .op(op),
        .carry(carry),
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
            A = 8'h0;
            B = 8'h0;
            op = 3'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 8'd5;
            B = 8'd10;
            op = 3'b000;
            @(posedge clk);
            #2;
            $display("Test 001: Addition (5 + 10)");
            #1;

            check_outputs(1'b0, 8'd15, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 8'hFF;
            B = 8'h01;
            op = 3'b000;
            @(posedge clk);
            #2;
            $display("Test 002: Addition with Carry (255 + 1)");
            #1;

            check_outputs(1'b1, 8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 8'd10;
            B = 8'd4;
            op = 3'b001;
            @(posedge clk);
            #2;
            $display("Test 003: Subtraction (10 - 4)");
            #1;

            check_outputs(1'b0, 8'h06, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 8'hAA;
            B = 8'hF0;
            op = 3'b010;
            @(posedge clk);
            #2;
            $display("Test 004: Bitwise AND");
            #1;

            check_outputs(1'b0, 8'hA0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 8'h55;
            B = 8'hAA;
            op = 3'b011;
            @(posedge clk);
            #2;
            $display("Test 005: Bitwise OR");
            #1;

            check_outputs(1'b0, 8'hFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 8'hFF;
            B = 8'hAA;
            op = 3'b100;
            @(posedge clk);
            #2;
            $display("Test 006: Bitwise XOR");
            #1;

            check_outputs(1'b0, 8'h55, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 8'h01;
            B = 8'h00;
            op = 3'b101;
            @(posedge clk);
            #2;
            $display("Test 007: Left Shift (0x01 << 1)");
            #1;

            check_outputs(1'b0, 8'h02, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 8'h80;
            op = 3'b110;
            @(posedge clk);
            #2;
            $display("Test 008: Right Shift (0x80 >> 1)");
            #1;

            check_outputs(1'b0, 8'h40, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            A = 8'hF0;
            B = 8'h0F;
            op = 3'b010;
            @(posedge clk);
            #2;
            $display("Test 009: Result Zero Flag Check (AND)");
            #1;

            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            A = 8'hFF;
            B = 8'hFF;
            op = 3'b000;
            @(posedge clk);
            #2;
            $display("Test 010: Addition Max Boundary (255 + 255)");
            #1;

            check_outputs(1'b1, 8'hFE, 1'b0);
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
        input expected_carry;
        input [7:0] expected_out;
        input expected_zero;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, out=%h, zero=%b",
                         carry, out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, out=%h, zero=%b",
                         expected_carry, expected_out, expected_zero);
                $display("  Got:      carry=%b, out=%h, zero=%b",
                         carry, out, zero);
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
        $dumpvars(0,A, B, clk, op, carry, out, zero);
    end

endmodule
