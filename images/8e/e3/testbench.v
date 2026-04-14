`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    wire [7:0] out;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
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
            a <= 8'h00;
            b <= 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: All bits high (FF & FF)");
            reset_dut();
            a <= 8'hFF;
            b <= 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: All bits low (00 & 00)");
            reset_dut();
            a <= 8'h00;
            b <= 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Alternating bits (AA & 55)");
            reset_dut();
            a <= 8'hAA;
            b <= 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Identical patterns (12 & 12)");
            reset_dut();
            a <= 8'h12;
            b <= 8'h12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h12, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Complementary Nibbles (F0 & 0F)");
            reset_dut();
            a <= 8'hF0;
            b <= 8'h0F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Random Overlap (C3 & E7)");
            reset_dut();
            a <= 8'hC3;
            b <= 8'hE7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hC3, 1'b1);
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
        $dumpvars(0,a, b, clk, out, out_valid);
    end

endmodule
