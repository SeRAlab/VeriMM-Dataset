`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_ena;
    reg [7:0] dfload;
    reg load;
    reg rst;
    wire carry;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_ena(clk_ena),
        .dfload(dfload),
        .load(load),
        .rst(rst),
        .carry(carry),
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
        clk_ena = 0;
        load = 0;
        dfload = 8'h00;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: Reset behavior", test_num);
        reset_dut();
        @(posedge clk);
        #1 #1;
 check_outputs(0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: Synchronous Load", test_num);
        reset_dut();
        dfload = 8'hA5;
        load = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(0, 8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Simple Incrementing (5 cycles)", test_num);
        reset_dut();
        clk_ena = 1;
        repeat (5) @(posedge clk);
        #1 #1;
 check_outputs(0, 8'h05);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: Clock Enable Gating (Disable check)", test_num);
        reset_dut();
        clk_ena = 0;
        repeat (10) @(posedge clk);
        #1 #1;
 check_outputs(0, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: Load Priority Over Enable", test_num);
        reset_dut();
        dfload = 8'h77;
        load = 1;
        clk_ena = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(0, 8'h77);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: Counter Wrap Around", test_num);
        reset_dut();
        dfload = 8'hFF;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        clk_ena = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest %0d: Carry Bit at Max Value", test_num);
        reset_dut();
        dfload = 8'hFE;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        clk_ena = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1, 8'hFF);
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
        input expected_carry;
        input [7:0] expected_count;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, count=%h",
                         carry, count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, count=%h",
                         expected_carry, expected_count);
                $display("  Got:      carry=%b, count=%h",
                         carry, count);
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
        $dumpvars(0,clk, clk_ena, dfload, load, rst, carry, count);
    end

endmodule
