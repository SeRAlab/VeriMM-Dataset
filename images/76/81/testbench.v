`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] ce;
    reg clk;
    reg ctrl;
    reg [1:0] reset;
    wire [3:0] count1;
    wire [3:0] count2;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .ctrl(ctrl),
        .reset(reset),
        .count1(count1),
        .count2(count2),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 2'b11;
            ce = 2'b00;
            ctrl = 0;
            #12;
            reset = 2'b00;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Basic Reset", test_num);
            #1;

            check_outputs(4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Counter 1 Increment", test_num);
            ce = 2'b01;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5, 4'd0, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Counter 2 Increment", test_num);
            ce = 2'b10;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd8, 4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Simultaneous Increment and Sum", test_num);
            ce = 2'b11;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd3, 4'd3, 4'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Rollover and Sum Wrapping", test_num);

            ce = 2'b11;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd10, 4'd10, 4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Individual Asynchronous Reset", test_num);
            ce = 2'b11;
            repeat(5) @(posedge clk);
            #2;
            reset = 2'b01;
            #5;
            reset = 2'b00;
            #1;

            #1;


            check_outputs(4'd0, 4'd5, 4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: Clock Enable Verification", test_num);
            ce = 2'b11;
            repeat(4) @(posedge clk);
            ce = 2'b00;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 4'd4, 4'd8);
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
        input [3:0] expected_count1;
        input [3:0] expected_count2;
        input [3:0] expected_sum;
        begin
            if (expected_count1 === (expected_count1 ^ count1 ^ expected_count1) &&
                expected_count2 === (expected_count2 ^ count2 ^ expected_count2) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: count1=%h, count2=%h, sum=%h",
                         count1, count2, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count1=%h, count2=%h, sum=%h",
                         expected_count1, expected_count2, expected_sum);
                $display("  Got:      count1=%h, count2=%h, sum=%h",
                         count1, count2, sum);
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
        $dumpvars(0,ce, clk, ctrl, reset, count1, count2, sum);
    end

endmodule
