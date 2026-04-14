`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [27:0] mux_4_output;
    reg res;
    reg [7:0] shift_left_bits;
    reg shift_left_en;
    reg [7:0] shift_right_bits;
    reg shift_right_en;
    wire [27:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mux_4_output(mux_4_output),
        .res(res),
        .shift_left_bits(shift_left_bits),
        .shift_left_en(shift_left_en),
        .shift_right_bits(shift_right_bits),
        .shift_right_en(shift_right_en),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        res = 1;
        mux_4_output = 28'h0;
        shift_left_bits = 8'h0;
        shift_left_en = 0;
        shift_right_bits = 8'h0;
        shift_right_en = 0;
        @(posedge clk);
        #1 res = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        mux_4_output = 28'h5AAAAA0;
        shift_left_en = 0;
        shift_right_en = 0;
        @(posedge clk);
        #2 #1;
 check_outputs(28'h5AAAAA1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        mux_4_output = 28'h000000A;
        shift_left_bits = 8'd4;
        shift_left_en = 1;
        shift_right_en = 0;
        @(posedge clk);
        #2 #1;
 check_outputs(28'h00000A1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        mux_4_output = 28'h00000A0;
        shift_right_bits = 8'd4;
        shift_left_en = 0;
        shift_right_en = 1;
        @(posedge clk);
        #2 #1;
 check_outputs(28'h000000B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        mux_4_output = 28'h8000000;
        shift_left_bits = 8'd1;
        shift_left_en = 1;
        @(posedge clk);
        #2 #1;
 check_outputs(28'h8000001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        mux_4_output = 28'h8000000;
        shift_right_bits = 8'd1;
        shift_right_en = 1;
        @(posedge clk);
        #2 #1;
 check_outputs(28'hC000001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        mux_4_output = 28'h7FFFFFF;
        shift_left_bits = 8'd30;
        shift_left_en = 1;
        @(posedge clk);
        #2 #1;
 check_outputs(28'h0000001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        mux_4_output = 28'hFFFFFFF;
        shift_right_bits = 8'd30;
        shift_right_en = 1;
        @(posedge clk);
        #2 #1;
 check_outputs(28'h8000001);
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
        input [27:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, mux_4_output, res, shift_left_bits, shift_left_en, shift_right_bits, shift_right_en, out);
    end

endmodule
