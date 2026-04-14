`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [3:0] min0;
    wire [2:0] min1;
    wire [3:0] sec0;
    wire [2:0] sec1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .min0(min0),
        .min1(min1),
        .sec0(sec0),
        .sec1(sec1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 3'd0, 4'd0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 9 Seconds Check", test_num);
            reset_dut();
            repeat(9) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 3'd0, 4'd9, 3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 10 Seconds Rollover Check", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 3'd0, 4'd0, 3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 59 Seconds Check", test_num);
            reset_dut();
            repeat(59) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 3'd0, 4'd9, 3'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1 Minute Rollover Check", test_num);
            reset_dut();
            repeat(60) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1, 3'd0, 4'd0, 3'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 10 Minutes Rollover Check", test_num);
            reset_dut();
            repeat(600) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 3'd1, 4'd0, 3'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 59 Minutes 59 Seconds Check", test_num);
            reset_dut();
            repeat(3599) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd9, 3'd5, 4'd9, 3'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Clock Rollover (60 min) Check", test_num);
            reset_dut();
            repeat(3600) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 3'd0, 4'd0, 3'd0);
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
        input [3:0] expected_min0;
        input [2:0] expected_min1;
        input [3:0] expected_sec0;
        input [2:0] expected_sec1;
        begin
            if (expected_min0 === (expected_min0 ^ min0 ^ expected_min0) &&
                expected_min1 === (expected_min1 ^ min1 ^ expected_min1) &&
                expected_sec0 === (expected_sec0 ^ sec0 ^ expected_sec0) &&
                expected_sec1 === (expected_sec1 ^ sec1 ^ expected_sec1)) begin
                $display("PASS");
                $display("  Outputs: min0=%h, min1=%h, sec0=%h, sec1=%h",
                         min0, min1, sec0, sec1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min0=%h, min1=%h, sec0=%h, sec1=%h",
                         expected_min0, expected_min1, expected_sec0, expected_sec1);
                $display("  Got:      min0=%h, min1=%h, sec0=%h, sec1=%h",
                         min0, min1, sec0, sec1);
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
        $dumpvars(0,clk, rst, min0, min1, sec0, sec1);
    end

endmodule
