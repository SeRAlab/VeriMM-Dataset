`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg [3:0] func;
    wire [31:0] alu_out;
    wire carry_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .func(func),
        .alu_out(alu_out),
        .carry_out(carry_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            func = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Addition (5 + 10)");
            a = 32'd5;
            b = 32'd10;
            func = 4'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd15, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Addition with Carry (0xFFFFFFFF + 1)");
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            func = 4'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Subtraction (50 - 20)");
            a = 32'd50;
            b = 32'd20;
            func = 4'h1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd30, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Multiplication (12 * 10)");
            a = 32'd12;
            b = 32'd10;
            func = 4'h2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd120, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Bitwise AND");
            a = 32'hF0F0F0F0;
            b = 32'hAAAA5555;
            func = 4'h7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hA0A05050, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Bitwise OR");
            a = 32'hF0F0F0F0;
            b = 32'h0F0F0F0F;
            func = 4'h8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: Shift Left Logical (1 << 4)");
            a = 32'h00000001;
            b = 32'd4;
            func = 4'h4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000010, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Testcase 008: Shift Right Logical (0x80 >> 2)");
            a = 32'h00000080;
            b = 32'd2;
            func = 4'h5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000020, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            $display("Testcase 009: Division (100 / 4)");
            a = 32'd100;
            b = 32'd4;
            func = 4'h3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd25, 1'b0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            $display("Testcase 010: Bitwise NOT (A)");
            a = 32'h00000000;
            b = 32'hFFFFFFFF;
            func = 4'hB;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
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
        input [31:0] expected_alu_out;
        input expected_carry_out;
        begin
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out) &&
                expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h, carry_out=%b",
                         alu_out, carry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h, carry_out=%b",
                         expected_alu_out, expected_carry_out);
                $display("  Got:      alu_out=%h, carry_out=%b",
                         alu_out, carry_out);
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
        $dumpvars(0,a, b, clk, func, alu_out, carry_out);
    end

endmodule
