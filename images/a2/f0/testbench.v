`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg rst_n;
    wire day_en;
    wire [3:0] hour0;
    wire [3:0] hour1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .rst_n(rst_n),
        .day_en(day_en),
        .hour0(hour0),
        .hour1(hour1)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_n = 0;
            @(posedge clk_i);
            #1;
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Advance to 09:00", test_num);
            reset_dut();
            for (i = 0; i < 9; i = i + 1) @(posedge clk_i);
            #1;
            #1;

            check_outputs(0, 4'h9, 4'h0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Rollover from 09:00 to 10:00", test_num);
            reset_dut();
            for (i = 0; i < 10; i = i + 1) @(posedge clk_i);
            #1;
            #1;

            check_outputs(0, 4'h0, 4'h1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Advance to 19:00", test_num);
            reset_dut();
            for (i = 0; i < 19; i = i + 1) @(posedge clk_i);
            #1;
            #1;

            check_outputs(0, 4'h9, 4'h1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Rollover from 19:00 to 20:00", test_num);
            reset_dut();
            for (i = 0; i < 20; i = i + 1) @(posedge clk_i);
            #1;
            #1;

            check_outputs(0, 4'h0, 4'h2);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Max hour 23:00", test_num);
            reset_dut();
            for (i = 0; i < 23; i = i + 1) @(posedge clk_i);
            #1;
            #1;

            check_outputs(0, 4'h3, 4'h2);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Day Rollover (23 to 00) and day_en", test_num);
            reset_dut();
            for (i = 0; i < 24; i = i + 1) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1, 4'h0, 4'h0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Advance to 01:00 on second day", test_num);
            reset_dut();
            for (i = 0; i < 25; i = i + 1) @(posedge clk_i);
            #1;
            #1;

            check_outputs(0, 4'h1, 4'h0);
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
        input expected_day_en;
        input [3:0] expected_hour0;
        input [3:0] expected_hour1;
        begin
            if (expected_day_en === (expected_day_en ^ day_en ^ expected_day_en) &&
                expected_hour0 === (expected_hour0 ^ hour0 ^ expected_hour0) &&
                expected_hour1 === (expected_hour1 ^ hour1 ^ expected_hour1)) begin
                $display("PASS");
                $display("  Outputs: day_en=%b, hour0=%h, hour1=%h",
                         day_en, hour0, hour1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: day_en=%b, hour0=%h, hour1=%h",
                         expected_day_en, expected_hour0, expected_hour1);
                $display("  Got:      day_en=%b, hour0=%h, hour1=%h",
                         day_en, hour0, hour1);
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
        $dumpvars(0,clk_i, rst_n, day_en, hour0, hour1);
    end

endmodule
