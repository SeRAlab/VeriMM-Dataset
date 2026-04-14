`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [3:0] leds_0;
    wire [3:0] leds_1;
    wire [3:0] leds_2;
    wire [3:0] leds_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .leds_0(leds_0),
        .leds_1(leds_1),
        .leds_2(leds_2),
        .leds_3(leds_3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Checking initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'hf, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Checking state after 1 clock cycle", test_num);
            reset_dut();
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 4'hf, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Checking state after 2 clock cycles", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 4'h0, 4'hf, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Checking state after 3 clock cycles", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'hf);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Checking wrap-around behavior after 4 clock cycles", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(4'hf, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Checking mid-sequence reset", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #2;
            rst = 1;
            #20;
            rst = 0;
            #10;

            #1;


            check_outputs(4'hf, 4'h0, 4'h0, 4'h0);
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
        input [3:0] expected_leds_0;
        input [3:0] expected_leds_1;
        input [3:0] expected_leds_2;
        input [3:0] expected_leds_3;
        begin
            if (expected_leds_0 === (expected_leds_0 ^ leds_0 ^ expected_leds_0) &&
                expected_leds_1 === (expected_leds_1 ^ leds_1 ^ expected_leds_1) &&
                expected_leds_2 === (expected_leds_2 ^ leds_2 ^ expected_leds_2) &&
                expected_leds_3 === (expected_leds_3 ^ leds_3 ^ expected_leds_3)) begin
                $display("PASS");
                $display("  Outputs: leds_0=%h, leds_1=%h, leds_2=%h, leds_3=%h",
                         leds_0, leds_1, leds_2, leds_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leds_0=%h, leds_1=%h, leds_2=%h, leds_3=%h",
                         expected_leds_0, expected_leds_1, expected_leds_2, expected_leds_3);
                $display("  Got:      leds_0=%h, leds_1=%h, leds_2=%h, leds_3=%h",
                         leds_0, leds_1, leds_2, leds_3);
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
        $dumpvars(0,clk, rst, leds_0, leds_1, leds_2, leds_3);
    end

endmodule
