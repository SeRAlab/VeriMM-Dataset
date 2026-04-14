`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg in_valid;
    reg rst;
    wire [31:0] out;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .in_valid(in_valid),
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
        in = 0;
        in_valid = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single input sum", test_num);
        reset_dut();


        in = 32'd100;
        in_valid = 1;
        @(posedge clk);
        #1;


        in_valid = 0;
        in = 32'd0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'd100, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple consecutive inputs", test_num);
        reset_dut();


        in = 32'd10; in_valid = 1; @(posedge clk); #1;
        in = 32'd20; in_valid = 1; @(posedge clk); #1;
        in = 32'd30; in_valid = 1; @(posedge clk); #1;
        in = 32'd40; in_valid = 1; @(posedge clk); #1;


        in_valid = 0;
        in = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'd100, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Overflow wrap-around", test_num);
        reset_dut();


        in = 32'hFFFFFFFF; in_valid = 1; @(posedge clk); #1;
        in = 32'h00000005; in_valid = 1; @(posedge clk); #1;

        in_valid = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h00000004, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Sequential batches", test_num);
        reset_dut();


        in = 32'd5; in_valid = 1; @(posedge clk); #1;
        in = 32'd5; in_valid = 1; @(posedge clk); #1;
        in_valid = 0; @(posedge clk); #1;

        if (out == 32'd10 && out_valid == 1'b1) begin

             in = 32'd50; in_valid = 1; @(posedge clk); #1;
             in = 32'd25; in_valid = 1; @(posedge clk); #1;
             in_valid = 0; @(posedge clk); #1;
             #1;

             check_outputs(32'd75, 1'b1);
        end else begin
             #1;

             check_outputs(32'd10, 1'b1);
        end
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset during accumulation", test_num);
        reset_dut();


        in = 32'd500; in_valid = 1; @(posedge clk); #1;


        rst = 1; @(posedge clk); #1;
        rst = 0;


        in = 32'd200; in_valid = 1; @(posedge clk); #1;
        in_valid = 0; @(posedge clk); #1;


        #1;



        check_outputs(32'd200, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: No valid input test", test_num);
        reset_dut();


        repeat(3) @(posedge clk);
        #1;


        #1;



        check_outputs(out, 1'b0);
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
        input [31:0] expected_out;
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
        $dumpvars(0,clk, in, in_valid, rst, out, out_valid);
    end

endmodule
