`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg left;
    reg right;
    reg rst;
    reg up;
    wire [7:0] direction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .down(down),
        .left(left),
        .right(right),
        .rst(rst),
        .up(up),
        .direction(direction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            up = 0;
            down = 0;
            left = 0;
            right = 0;
            repeat(10) @(posedge clk);
            rst = 0;
            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            repeat(10) @(posedge clk);
            #1;

            check_outputs(DIR_NONE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            up = 1;

            repeat(SAMPLE_TIME + 10) @(posedge clk);
            #1;

            check_outputs(DIR_UP);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            down = 1;
            repeat(SAMPLE_TIME + 10) @(posedge clk);
            #1;

            check_outputs(DIR_DOWN);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            left = 1;
            repeat(SAMPLE_TIME + 10) @(posedge clk);
            #1;

            check_outputs(DIR_LEFT);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            right = 1;
            repeat(SAMPLE_TIME + 10) @(posedge clk);
            #1;

            check_outputs(DIR_RIGHT);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            up = 1;
            repeat(SAMPLE_TIME + 10) @(posedge clk);

            up = 0;

            repeat(SAMPLE_TIME + 10) @(posedge clk);
            #1;

            check_outputs(DIR_NONE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            right = 1;

            repeat(SAMPLE_TIME * 2 + 10) @(posedge clk);
            #1;

            check_outputs(DIR_RIGHT);
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
        input [7:0] expected_direction;
        begin
            if (expected_direction === (expected_direction ^ direction ^ expected_direction)) begin
                $display("PASS");
                $display("  Outputs: direction=%h",
                         direction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: direction=%h",
                         expected_direction);
                $display("  Got:      direction=%h",
                         direction);
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
        $dumpvars(0,clk, down, left, right, rst, up, direction);
    end

endmodule
