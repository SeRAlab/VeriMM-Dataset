`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire isFinished;
    wire [3:0] one;
    wire [3:0] ten;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .isFinished(isFinished),
        .one(one),
        .ten(ten)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'd0, 4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: First countdown step (30 to 29)", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'd9, 4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Countdown across tens (30 to 19)", test_num);
            reset_dut();
            repeat(11) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'd9, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Reaching Zero (30 to 00)", test_num);
            reset_dut();
            repeat(30) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Post-terminal state (31 cycles)", test_num);
            reset_dut();
            repeat(31) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'd0, 4'd0);
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
        input expected_isFinished;
        input [3:0] expected_one;
        input [3:0] expected_ten;
        begin
            if (expected_isFinished === (expected_isFinished ^ isFinished ^ expected_isFinished) &&
                expected_one === (expected_one ^ one ^ expected_one) &&
                expected_ten === (expected_ten ^ ten ^ expected_ten)) begin
                $display("PASS");
                $display("  Outputs: isFinished=%b, one=%h, ten=%h",
                         isFinished, one, ten);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: isFinished=%b, one=%h, ten=%h",
                         expected_isFinished, expected_one, expected_ten);
                $display("  Got:      isFinished=%b, one=%h, ten=%h",
                         isFinished, one, ten);
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
        $dumpvars(0,clk, rst_n, isFinished, one, ten);
    end

endmodule
