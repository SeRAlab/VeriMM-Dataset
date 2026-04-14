`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_col_index;
    reg push_in;
    reg reset;
    wire [31:0] out_col_index;
    wire [4:0] out_count;
    wire push_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_col_index(in_col_index),
        .push_in(push_in),
        .reset(reset),
        .out_col_index(out_col_index),
        .out_count(out_count),
        .push_out(push_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            push_in = 0;
            in_col_index = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Single Transition", test_num);
            reset_dut();

            in_col_index = 32'hAAAA_AAAA;
            push_in = 1;
            @(posedge clk);
            #1;

            in_col_index = 32'hBBBB_BBBB;
            push_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hAAAA_AAAA, 5'd1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Pushes (Count=3)", test_num);
            reset_dut();

            in_col_index = 32'h0000_0005;
            push_in = 1;
            repeat(3) @(posedge clk);
            #1;

            in_col_index = 32'h0000_0009;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_0005, 5'd3, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter Saturation (Max 31)", test_num);
            reset_dut();

            in_col_index = 32'hFFFF_0000;
            push_in = 1;
            repeat(35) @(posedge clk);
            #1;

            in_col_index = 32'h0000_FFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFF_0000, 5'd31, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Push with Gaps", test_num);
            reset_dut();

            in_col_index = 32'h0000_0007;
            push_in = 1;
            @(posedge clk); #1;
            push_in = 0;
            @(posedge clk); #1;
            push_in = 1;
            @(posedge clk); #1;

            in_col_index = 32'h0000_0008;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h0000_0007, 5'd2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Back-to-back Transitions", test_num);
            reset_dut();

            in_col_index = 32'h1; push_in = 1;
            @(posedge clk); #1;
            in_col_index = 32'h2;
            @(posedge clk); #1;
            in_col_index = 32'h3;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h2, 5'd1, 1'b1);
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
        input [31:0] expected_out_col_index;
        input [4:0] expected_out_count;
        input expected_push_out;
        begin
            if (expected_out_col_index === (expected_out_col_index ^ out_col_index ^ expected_out_col_index) &&
                expected_out_count === (expected_out_count ^ out_count ^ expected_out_count) &&
                expected_push_out === (expected_push_out ^ push_out ^ expected_push_out)) begin
                $display("PASS");
                $display("  Outputs: out_col_index=%h, out_count=%h, push_out=%b",
                         out_col_index, out_count, push_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_col_index=%h, out_count=%h, push_out=%b",
                         expected_out_col_index, expected_out_count, expected_push_out);
                $display("  Got:      out_col_index=%h, out_count=%h, push_out=%b",
                         out_col_index, out_count, push_out);
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
        $dumpvars(0,clk, in_col_index, push_in, reset, out_col_index, out_count, push_out);
    end

endmodule
