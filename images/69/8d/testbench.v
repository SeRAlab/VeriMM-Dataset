`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg dst_rdy_i;
    reg [15:0] len;
    reg reset;
    wire [35:0] data_o;
    wire src_rdy_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .dst_rdy_i(dst_rdy_i),
        .len(len),
        .reset(reset),
        .data_o(data_o),
        .src_rdy_o(src_rdy_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 0;
            len = 0;
            dst_rdy_i = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Packet Len 4", test_num);
            len = 16'd4;
            dst_rdy_i = 1'b1;



            repeat(4) @(posedge clk);

            #1;

            #1;


            check_outputs({4'h4, data_o[31:0]}, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Backpressure Stall", test_num);
            len = 16'd5;
            dst_rdy_i = 1'b1;

            @(posedge clk);
            dst_rdy_i = 1'b0;
            repeat(3) @(posedge clk);
            dst_rdy_i = 1'b1;
            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs({4'h4, data_o[31:0]}, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Minimum Length Packet", test_num);
            len = 16'd2;
            dst_rdy_i = 1'b1;

            repeat(2) @(posedge clk);

            #1;
            #1;

            check_outputs({4'h4, data_o[31:0]}, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Clear Activation", test_num);
            len = 16'd8;
            dst_rdy_i = 1'b1;

            repeat(3) @(posedge clk);
            clear = 1'b1;
            @(posedge clk);
            clear = 1'b0;


            @(posedge clk);
            #1;

            #1;


            check_outputs({4'h8, data_o[31:0]}, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Long Packet", test_num);
            len = 16'd20;
            dst_rdy_i = 1'b1;

            repeat(20) @(posedge clk);

            #1;
            #1;

            check_outputs({4'h4, data_o[31:0]}, 1'b1);
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
        input [35:0] expected_data_o;
        input expected_src_rdy_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_src_rdy_o === (expected_src_rdy_o ^ src_rdy_o ^ expected_src_rdy_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, src_rdy_o=%b",
                         data_o, src_rdy_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, src_rdy_o=%b",
                         expected_data_o, expected_src_rdy_o);
                $display("  Got:      data_o=%h, src_rdy_o=%b",
                         data_o, src_rdy_o);
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
        $dumpvars(0,clear, clk, dst_rdy_i, len, reset, data_o, src_rdy_o);
    end

endmodule
