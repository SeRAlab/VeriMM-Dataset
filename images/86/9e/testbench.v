`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    reg zero;
    wire [6:0] min;
    wire [14:0] msec;
    wire [6:0] sec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .zero(zero),
        .min(min),
        .msec(msec),
        .sec(sec)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            zero = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Millisecond Counting (500 cycles)", test_num);
            reset_dut();
            enable = 1;
            repeat(500) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(0, 500, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rollover from msec to sec (1000 cycles)", test_num);
            reset_dut();
            enable = 1;
            repeat(1000) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rollover from sec to min (60,000 cycles)", test_num);
            reset_dut();
            enable = 1;

            repeat(60000) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable/Disable behavior", test_num);
            reset_dut();
            enable = 1;
            repeat(100) @(posedge clk);
            enable = 0;
            repeat(100) @(posedge clk);
            enable = 1;
            repeat(50) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(0, 150, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero signal during operation", test_num);
            reset_dut();
            enable = 1;
            repeat(1500) @(posedge clk);


            zero = 1;
            @(posedge clk);
            zero = 0;


            repeat(10) @(posedge clk);
            enable = 0;
            #1;


            #1;



            check_outputs(0, 10, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rollover to 2nd minute", test_num);
            reset_dut();
            enable = 1;



            repeat(90000) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(1, 0, 30);
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
        input [6:0] expected_min;
        input [14:0] expected_msec;
        input [6:0] expected_sec;
        begin
            if (expected_min === (expected_min ^ min ^ expected_min) &&
                expected_msec === (expected_msec ^ msec ^ expected_msec) &&
                expected_sec === (expected_sec ^ sec ^ expected_sec)) begin
                $display("PASS");
                $display("  Outputs: min=%h, msec=%h, sec=%h",
                         min, msec, sec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min=%h, msec=%h, sec=%h",
                         expected_min, expected_msec, expected_sec);
                $display("  Got:      min=%h, msec=%h, sec=%h",
                         min, msec, sec);
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
        $dumpvars(0,clk, enable, rst, zero, min, msec, sec);
    end

endmodule
