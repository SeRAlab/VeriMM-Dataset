`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst;
    wire [7:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .out(out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            a = 8'h00;
            b = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Behavior", test_num);

            @(posedge clk);
            rst = 1;
            a = 8'hFF; b = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b0);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Standard AND (0x55 & 0xAA)", test_num);
            reset_dut();
            a = 8'h55; b = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Identity AND (0xFF & 0xA5)", test_num);
            reset_dut();
            a = 8'hFF; b = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Zero AND (0x00 & 0xFF)", test_num);
            reset_dut();
            a = 8'h00; b = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Bitwise Masking (0xF0 & 0xCC)", test_num);
            reset_dut();
            a = 8'hF0; b = 8'hCC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hC0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: All Bits High (0xFF & 0xFF)", test_num);
            reset_dut();
            a = 8'hFF; b = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b1);
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
        input [7:0] expected_out;
        input expected_valid;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, valid=%b",
                         out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, valid=%b",
                         expected_out, expected_valid);
                $display("  Got:      out=%h, valid=%b",
                         out, valid);
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
        $dumpvars(0,a, b, clk, rst, out, valid);
    end

endmodule
