`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg decrease;
    reg [3:0] init_value;
    reg [3:0] limit;
    reg restart;
    reg rst_n;
    reg [3:0] start_value;
    wire borrow;
    wire [3:0] value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .decrease(decrease),
        .init_value(init_value),
        .limit(limit),
        .restart(restart),
        .rst_n(rst_n),
        .start_value(start_value),
        .borrow(borrow),
        .value(value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            decrease = 0;
            init_value = 0;
            limit = 0;
            start_value = 0;
            restart = 0;
            #10;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Value", test_num);
            init_value = 4'd5;
            reset_dut();
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Decrement", test_num);
            init_value = 4'd9;
            reset_dut();
            @(posedge clk);
            #1;
            decrease = 1;
            @(posedge clk);
            #1;
            decrease = 0;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Wrap-around (0 to 9)", test_num);
            init_value = 4'd0;
            limit = 4'd0;
            start_value = 4'd9;
            reset_dut();
            @(posedge clk);
            #1;
            decrease = 1;
            @(posedge clk);
            #1;
            decrease = 0;
            #1;

            check_outputs(1'b1, 4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Hold Value (Decrease=0)", test_num);
            init_value = 4'd7;
            reset_dut();
            @(posedge clk);
            #1;
            decrease = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Restart to Init Value", test_num);
            init_value = 4'd8;
            reset_dut();
            @(posedge clk);
            #1;
            decrease = 1;
            repeat(2) @(posedge clk);
            #1;
            decrease = 0;
            restart = 1;
            @(posedge clk);
            #1;
            restart = 0;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiple Decrements to Wrap", test_num);
            init_value = 4'd2;
            limit = 4'd0;
            start_value = 4'd9;
            reset_dut();
            @(posedge clk);
            #1;
            decrease = 1;
            repeat(2) @(posedge clk);
            #1;

            @(posedge clk);
            #1;
            decrease = 0;
            #1;

            check_outputs(1'b1, 4'd9);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Custom Limit/Start Range", test_num);
            init_value = 4'd5;
            limit = 4'd4;
            start_value = 4'hF;
            reset_dut();
            @(posedge clk);
            #1;
            decrease = 1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            decrease = 0;
            #1;

            check_outputs(1'b1, 4'hF);
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
        input expected_borrow;
        input [3:0] expected_value;
        begin
            if (expected_borrow === (expected_borrow ^ borrow ^ expected_borrow) &&
                expected_value === (expected_value ^ value ^ expected_value)) begin
                $display("PASS");
                $display("  Outputs: borrow=%b, value=%h",
                         borrow, value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow=%b, value=%h",
                         expected_borrow, expected_value);
                $display("  Got:      borrow=%b, value=%h",
                         borrow, value);
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
        $dumpvars(0,clk, decrease, init_value, limit, restart, rst_n, start_value, borrow, value);
    end

endmodule
