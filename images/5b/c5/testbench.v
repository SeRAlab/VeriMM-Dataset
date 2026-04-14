`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg load;
    reg [15:0] load_val;
    reg rst;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .load(load),
        .load_val(load_val),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        ctrl = 1;
        load = 0;
        load_val = 16'h0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Increment 5 times", test_num);
        reset_dut();
        ctrl = 1;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(16'h0005);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Decrement 3 times from zero", test_num);
        reset_dut();
        ctrl = 0;
        repeat(3) @(posedge clk);
        #1 #1;
 check_outputs(16'hFFFD);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: Load specific value 0xABCD", test_num);
        reset_dut();
        load_val = 16'hABCD;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: Load 0x00FE then increment twice", test_num);
        reset_dut();
        load_val = 16'h00FE;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        ctrl = 1;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(16'h0100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %03d: Load 0x0002 then decrement three times", test_num);
        reset_dut();
        load_val = 16'h0002;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        ctrl = 0;
        repeat(3) @(posedge clk);
        #1 #1;
 check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %03d: Increment from 0xFFFF", test_num);
        reset_dut();
        load_val = 16'hFFFF;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        ctrl = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %03d: Up 10, then Down 5", test_num);
        reset_dut();
        ctrl = 1;
        repeat(10) @(posedge clk);
        ctrl = 0;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(16'h0005);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %03d: Reset priority over Load", test_num);
        reset_dut();
        rst = 1;
        load = 1;
        load_val = 16'h5555;
        @(posedge clk);
        #1 rst = 0;
        load = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %03d: Large increment count", test_num);
        reset_dut();
        ctrl = 1;
        repeat(256) @(posedge clk);
        #1 #1;
 check_outputs(16'h0100);
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
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, ctrl, load, load_val, rst, count);
    end

endmodule
