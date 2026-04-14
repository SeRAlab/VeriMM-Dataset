`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [35:0] inp_data;
    reg inp_valid;
    reg out0_ready;
    reg out1_ready;
    reg rst;
    wire inp_ready;
    wire [35:0] out0_data;
    wire out0_valid;
    wire [35:0] out1_data;
    wire out1_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .inp_data(inp_data),
        .inp_valid(inp_valid),
        .out0_ready(out0_ready),
        .out1_ready(out1_ready),
        .rst(rst),
        .inp_ready(inp_ready),
        .out0_data(out0_data),
        .out0_valid(out0_valid),
        .out1_data(out1_data),
        .out1_valid(out1_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clr = 0;
            inp_data = 0;
            inp_valid = 0;
            out0_ready = 0;
            out1_ready = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset and Idle State", test_num);
            reset_dut();


            out0_ready = 1;
            out1_ready = 1;
            inp_valid = 0;
            #2;
            #1;

            check_outputs(1'b1, 36'h0, 1'b0, 36'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Simultaneous Transmission", test_num);
            reset_dut();
            inp_data = 36'hA_5555_AAAA;
            inp_valid = 1;
            out0_ready = 1;
            out1_ready = 1;
            #2;

            #1;


            check_outputs(1'b1, 36'hA_5555_AAAA, 1'b1, 36'hA_5555_AAAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Output 1 Stalls (Move to STATE_COPY_ONE)", test_num);
            reset_dut();

            inp_data = 36'hB_6666_BBBB;
            inp_valid = 1;
            out0_ready = 1;
            out1_ready = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 36'hB_6666_BBBB, 1'b0, 36'hB_6666_BBBB, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Output 0 Stalls (Move to STATE_COPY_ZERO)", test_num);
            reset_dut();
            inp_data = 36'hC_7777_CCCC;
            inp_valid = 1;
            out0_ready = 0;
            out1_ready = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 36'hC_7777_CCCC, 1'b1, 36'hC_7777_CCCC, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Clear during Stall", test_num);
            reset_dut();

            inp_data = 36'hD_8888_DDDD;
            inp_valid = 1;
            out0_ready = 1;
            out1_ready = 0;
            @(posedge clk);
            #1;

            clr = 1;
            @(posedge clk);
            #2;
            clr = 0;
            inp_valid = 0;
            #1;

            #1;


            check_outputs(1'b1, 36'hD_8888_DDDD, 1'b0, 36'hD_8888_DDDD, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Complete Transfer after Stall", test_num);
            reset_dut();

            inp_data = 36'hE_9999_EEEE;
            inp_valid = 1;
            out0_ready = 0;
            out1_ready = 1;
            @(posedge clk);
            #1;

            out0_ready = 1;
            @(posedge clk);
            #2;
            inp_valid = 0;

            #1;


            check_outputs(1'b1, 36'hE_9999_EEEE, 1'b0, 36'hE_9999_EEEE, 1'b0);
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
        input expected_inp_ready;
        input [35:0] expected_out0_data;
        input expected_out0_valid;
        input [35:0] expected_out1_data;
        input expected_out1_valid;
        begin
            if (expected_inp_ready === (expected_inp_ready ^ inp_ready ^ expected_inp_ready) &&
                expected_out0_data === (expected_out0_data ^ out0_data ^ expected_out0_data) &&
                expected_out0_valid === (expected_out0_valid ^ out0_valid ^ expected_out0_valid) &&
                expected_out1_data === (expected_out1_data ^ out1_data ^ expected_out1_data) &&
                expected_out1_valid === (expected_out1_valid ^ out1_valid ^ expected_out1_valid)) begin
                $display("PASS");
                $display("  Outputs: inp_ready=%b, out0_data=%h, out0_valid=%b, out1_data=%h, out1_valid=%b",
                         inp_ready, out0_data, out0_valid, out1_data, out1_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inp_ready=%b, out0_data=%h, out0_valid=%b, out1_data=%h, out1_valid=%b",
                         expected_inp_ready, expected_out0_data, expected_out0_valid, expected_out1_data, expected_out1_valid);
                $display("  Got:      inp_ready=%b, out0_data=%h, out0_valid=%b, out1_data=%h, out1_valid=%b",
                         inp_ready, out0_data, out0_valid, out1_data, out1_valid);
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
        $dumpvars(0,clk, clr, inp_data, inp_valid, out0_ready, out1_ready, rst, inp_ready, out0_data, out0_valid, out1_data, out1_valid);
    end

endmodule
