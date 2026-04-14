`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg max_or_min;
    reg [15:0] num_in1;
    reg [15:0] num_in2;
    reg reset;
    wire [15:0] num_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .max_or_min(max_or_min),
        .num_in1(num_in1),
        .num_in2(num_in2),
        .reset(reset),
        .num_out(num_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        num_in1 = 0;
        num_in2 = 0;
        max_or_min = 0;
        @(posedge clk);
        #1;
        reset = 0;

        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        num_in1 = 16'sd100;
        num_in2 = 16'sd500;
        max_or_min = 1;
        @(posedge clk);
        #1;
        $display("Test 1: Max of 100 and 500");
        #1;

        check_outputs(16'sd500);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        num_in1 = 16'sd100;
        num_in2 = 16'sd500;
        max_or_min = 0;
        @(posedge clk);
        #1;
        $display("Test 2: Min of 100 and 500");
        #1;

        check_outputs(16'sd100);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        num_in1 = -16'sd100;
        num_in2 = -16'sd500;
        max_or_min = 1;
        @(posedge clk);
        #1;
        $display("Test 3: Max of -100 and -500");
        #1;

        check_outputs(-16'sd100);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        num_in1 = -16'sd100;
        num_in2 = -16'sd500;
        max_or_min = 0;
        @(posedge clk);
        #1;
        $display("Test 4: Min of -100 and -500");
        #1;

        check_outputs(-16'sd500);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        num_in1 = 16'sd25;
        num_in2 = -16'sd25;
        max_or_min = 1;
        @(posedge clk);
        #1;
        $display("Test 5: Max of 25 and -25");
        #1;

        check_outputs(16'sd25);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        num_in1 = 16'sd25;
        num_in2 = -16'sd25;
        max_or_min = 0;
        @(posedge clk);
        #1;
        $display("Test 6: Min of 25 and -25");
        #1;

        check_outputs(-16'sd25);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        num_in1 = 16'sh7FFF;
        num_in2 = 16'sh8000;
        max_or_min = 1;
        @(posedge clk);
        #1;
        $display("Test 7: Max of 32767 and -32768");
        #1;

        check_outputs(16'sh7FFF);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        num_in1 = 16'sh7FFF;
        num_in2 = 16'sh8000;
        max_or_min = 0;
        @(posedge clk);
        #1;
        $display("Test 8: Min of 32767 and -32768");
        #1;

        check_outputs(16'sh8000);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        num_in1 = 16'sd1234;
        num_in2 = 16'sd1234;
        max_or_min = 1;
        @(posedge clk);
        #1;
        $display("Test 9: Equal values (1234, 1234) Max");
        #1;

        check_outputs(16'sd1234);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = 10;
        num_in1 = 16'sd0;
        num_in2 = -16'sd1;
        max_or_min = 1;
        @(posedge clk);
        #1;
        $display("Test 10: Max of 0 and -1");
        #1;

        check_outputs(16'sd0);
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
        input [15:0] expected_num_out;
        begin
            if (expected_num_out === (expected_num_out ^ num_out ^ expected_num_out)) begin
                $display("PASS");
                $display("  Outputs: num_out=%h",
                         num_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num_out=%h",
                         expected_num_out);
                $display("  Got:      num_out=%h",
                         num_out);
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
        $dumpvars(0,clk, max_or_min, num_in1, num_in2, reset, num_out);
    end

endmodule
