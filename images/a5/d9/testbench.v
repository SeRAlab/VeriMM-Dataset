`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] beverage;
    reg clk;
    reg en;
    reg [5:0] money;
    reg rst;
    wire [5:0] change;
    wire finish;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .beverage(beverage),
        .clk(clk),
        .en(en),
        .money(money),
        .rst(rst),
        .change(change),
        .finish(finish)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        en = 0;
        money = 0;
        beverage = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Standard transaction (20 - 5)", test_num);
        reset_dut();

        money = 6'd20;
        beverage = 6'd5;
        en = 1;
        @(posedge clk);
        #1 en = 0;


        wait(finish == 1'b1);
        #1;

        check_outputs(6'd15, 1'b1);
        @(posedge clk);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Exact change (10 - 10)", test_num);
        reset_dut();

        money = 6'd10;
        beverage = 6'd10;
        en = 1;
        @(posedge clk);
        #1 en = 0;

        wait(finish == 1'b1);
        #1;

        check_outputs(6'd0, 1'b1);
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Max values (63 - 1)", test_num);
        reset_dut();

        money = 6'd63;
        beverage = 6'd1;
        en = 1;
        @(posedge clk);
        #1 en = 0;

        wait(finish == 1'b1);
        #1;

        check_outputs(6'd62, 1'b1);
        @(posedge clk);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Min values (1 - 1)", test_num);
        reset_dut();

        money = 6'd1;
        beverage = 6'd1;
        en = 1;
        @(posedge clk);
        #1 en = 0;

        wait(finish == 1'b1);
        #1;

        check_outputs(6'd0, 1'b1);
        @(posedge clk);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Zero transaction (0 - 0)", test_num);
        reset_dut();

        money = 6'd0;
        beverage = 6'd0;
        en = 1;
        @(posedge clk);
        #1 en = 0;

        wait(finish == 1'b1);
        #1;

        check_outputs(6'd0, 1'b1);
        @(posedge clk);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Insufficient funds (5 - 10)", test_num);
        reset_dut();

        money = 6'd5;
        beverage = 6'd10;
        en = 1;
        @(posedge clk);
        #1 en = 0;

        wait(finish == 1'b1);
        #1;

        check_outputs(6'd59, 1'b1);
        @(posedge clk);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: High cost (50 - 40)", test_num);
        reset_dut();

        money = 6'd50;
        beverage = 6'd40;
        en = 1;
        @(posedge clk);
        #1 en = 0;

        wait(finish == 1'b1);
        #1;

        check_outputs(6'd10, 1'b1);
        @(posedge clk);
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
        input [5:0] expected_change;
        input expected_finish;
        begin
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_finish === (expected_finish ^ finish ^ expected_finish)) begin
                $display("PASS");
                $display("  Outputs: change=%h, finish=%b",
                         change, finish);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%h, finish=%b",
                         expected_change, expected_finish);
                $display("  Got:      change=%h, finish=%b",
                         change, finish);
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
        $dumpvars(0,beverage, clk, en, money, rst, change, finish);
    end

endmodule
