`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_valid;
    reg [18:0] instruction;
    reg rst;
    wire [15:0] out;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_valid(in_valid),
        .instruction(instruction),
        .rst(rst),
        .out(out),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_valid = 0;
            instruction = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Addition (10 + 20)");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            instruction = {3'b000, 8'd10, 8'd20};
            @(posedge clk);
            in_valid = 0;


            wait(out_valid == 1);
            #1;

            check_outputs(16'd30, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Subtraction (100 - 45)");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            instruction = {3'b001, 8'd100, 8'd45};
            @(posedge clk);
            in_valid = 0;

            wait(out_valid == 1);
            #1;

            check_outputs(16'd55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Bitwise AND (0xFF & 0x55)");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            instruction = {3'b010, 8'hFF, 8'h55};
            @(posedge clk);
            in_valid = 0;

            wait(out_valid == 1);
            #1;

            check_outputs(16'h0055, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Bitwise OR (0xAA | 0x55)");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            instruction = {3'b011, 8'hAA, 8'h55};
            @(posedge clk);
            in_valid = 0;

            wait(out_valid == 1);
            #1;

            check_outputs(16'h00FF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Bitwise XOR (0xF0 ^ 0x0F)");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            instruction = {3'b100, 8'hF0, 8'h0F};
            @(posedge clk);
            in_valid = 0;

            wait(out_valid == 1);
            #1;

            check_outputs(16'h00FF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Bitwise NOT (~0x00)");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            instruction = {3'b101, 8'h00, 8'h00};
            @(posedge clk);
            in_valid = 0;

            wait(out_valid == 1);
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Shift Left (0x01 << 4)");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            instruction = {3'b110, 8'h01, 8'h04};
            @(posedge clk);
            in_valid = 0;

            wait(out_valid == 1);
            #1;

            check_outputs(16'h0010, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Large Addition (255 + 255)");
            reset_dut();
            @(posedge clk);
            in_valid = 1;
            instruction = {3'b000, 8'd255, 8'd255};
            @(posedge clk);
            in_valid = 0;

            wait(out_valid == 1);
            #1;

            check_outputs(16'd510, 1'b1);
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
        input [15:0] expected_out;
        input expected_out_valid;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, out_valid=%b",
                         out, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, out_valid=%b",
                         expected_out, expected_out_valid);
                $display("  Got:      out=%h, out_valid=%b",
                         out, out_valid);
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
        $dumpvars(0,clk, in_valid, instruction, rst, out, out_valid);
    end

endmodule
