`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] in_data;
    reg rst;
    reg [3:0] threshold;
    wire [9:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .rst(rst),
        .threshold(threshold),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        in_data = 0;
        threshold = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive change above threshold", test_num);
        reset_dut();
        threshold = 4'h5;
        in_data = 10'd0;
        @(posedge clk);
        #1 in_data = 10'd10;
        @(posedge clk);
        #1 #1;
 check_outputs(10'h3FF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive change below threshold", test_num);
        reset_dut();
        threshold = 4'h8;
        in_data = 10'd0;
        @(posedge clk);
        #1 in_data = 10'd4;
        @(posedge clk);
        #1 #1;
 check_outputs(10'h000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative change above threshold", test_num);
        reset_dut();
        threshold = 4'h3;
        in_data = 10'd20;
        @(posedge clk);
        #1 in_data = 10'd10;
        @(posedge clk);
        #1 #1;
 check_outputs(10'h3FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Difference exactly equal to threshold", test_num);
        reset_dut();
        threshold = 4'd10;
        in_data = 10'd0;
        @(posedge clk);
        #1 in_data = 10'd10;
        @(posedge clk);
        #1 #1;
 check_outputs(10'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Consecutive data changes", test_num);
        reset_dut();
        threshold = 4'd2;
        in_data = 10'd10;
        @(posedge clk);
        #1 in_data = 10'd11;
        @(posedge clk);
        #1 #1;
 check_outputs(10'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum difference (0 to 1023)", test_num);
        reset_dut();
        threshold = 4'hF;
        in_data = 10'd0;
        @(posedge clk);
        #1 in_data = 10'h3FF;
        @(posedge clk);
        #1 #1;
 check_outputs(10'h3FF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Threshold set to 0 (any change triggers)", test_num);
        reset_dut();
        threshold = 4'd0;
        in_data = 10'd0;
        @(posedge clk);
        #1 in_data = 10'd1;
        @(posedge clk);
        #1 #1;
 check_outputs(10'h3FF);
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
        input [9:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, in_data, rst, threshold, out_data);
    end

endmodule
