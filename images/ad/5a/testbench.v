`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] completion_pending;
    reg np_tag_inc;
    reg rst;
    wire np_tag_gnt;
    wire [7:0] tag_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .completion_pending(completion_pending),
        .np_tag_inc(np_tag_inc),
        .rst(rst),
        .np_tag_gnt(np_tag_gnt),
        .tag_value(tag_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            np_tag_inc = 0;
            completion_pending = 32'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Basic Reset and Tag 0 check", test_num);
            reset_dut();


            completion_pending = 32'h0000_0000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Pending bit blocks grant at Tag 0", test_num);
            reset_dut();

            completion_pending = 32'h0000_0001;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Increment to Tag 1", test_num);
            reset_dut();
            @(posedge clk);
            np_tag_inc = 1;
            @(posedge clk);
            np_tag_inc = 0;
            completion_pending = 32'h0000_0000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'h01);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %03d: Increment to Tag 5 and check pending bit 5", test_num);
            reset_dut();

            for(i = 0; i < 5; i = i + 1) begin
                np_tag_inc = 1;
                @(posedge clk);
            end
            np_tag_inc = 0;

            completion_pending = 32'h0000_0020;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'h05);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %03d: Counter rollover check (31 to 0)", test_num);
            reset_dut();

            for(i = 0; i < 31; i = i + 1) begin
                np_tag_inc = 1;
                @(posedge clk);
            end
            np_tag_inc = 0;
            @(posedge clk);

            np_tag_inc = 1;
            @(posedge clk);
            np_tag_inc = 0;
            completion_pending = 32'h0000_0000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'h00);
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
        input expected_np_tag_gnt;
        input [7:0] expected_tag_value;
        begin
            if (expected_np_tag_gnt === (expected_np_tag_gnt ^ np_tag_gnt ^ expected_np_tag_gnt) &&
                expected_tag_value === (expected_tag_value ^ tag_value ^ expected_tag_value)) begin
                $display("PASS");
                $display("  Outputs: np_tag_gnt=%b, tag_value=%h",
                         np_tag_gnt, tag_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: np_tag_gnt=%b, tag_value=%h",
                         expected_np_tag_gnt, expected_tag_value);
                $display("  Got:      np_tag_gnt=%b, tag_value=%h",
                         np_tag_gnt, tag_value);
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
        $dumpvars(0,clk, completion_pending, np_tag_inc, rst, np_tag_gnt, tag_value);
    end

endmodule
