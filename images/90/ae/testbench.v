`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ain;
    reg [31:0] bin;
    reg clk;
    reg rst;
    wire [31:0] result;
    wire [31:0] statistic;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ain(ain),
        .bin(bin),
        .clk(clk),
        .rst(rst),
        .result(result),
        .statistic(statistic)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ain = 0;
            bin = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Max (ain > bin)", test_num);
            reset_dut();
            ain = 32'd100;
            bin = 32'd50;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'd100, STAT_BASE + 32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Max (bin > ain)", test_num);
            reset_dut();
            ain = 32'd40;
            bin = 32'd200;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd200, STAT_BASE + 32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Tracking multiple result changes", test_num);
            reset_dut();


            ain = 32'd50; bin = 32'd10;
            @(posedge clk); #2;


            ain = 32'd50; bin = 32'd75;
            @(posedge clk); #2;


            ain = 32'd1000; bin = 32'd75;
            @(posedge clk); #2;

            #1;


            check_outputs(32'd1000, STAT_BASE + 32'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs change but result remains same", test_num);
            reset_dut();


            ain = 32'd500; bin = 32'd100;
            @(posedge clk); #2;


            ain = 32'd500; bin = 32'd499;
            @(posedge clk); #2;


            ain = 32'd250; bin = 32'd500;
            @(posedge clk); #2;

            #1;


            check_outputs(32'd500, STAT_BASE + 32'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum 32-bit values", test_num);
            reset_dut();
            ain = 32'hFFFFFFFF;
            bin = 32'hFFFFFFFE;
            @(posedge clk); #2;
            #1;

            check_outputs(32'hFFFFFFFF, STAT_BASE + 32'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max is zero (no change from reset)", test_num);
            reset_dut();
            ain = 32'd0;
            bin = 32'd0;
            @(posedge clk); #2;

            #1;


            check_outputs(32'd0, STAT_BASE + 32'd0);
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
        input [31:0] expected_result;
        input [31:0] expected_statistic;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_statistic === (expected_statistic ^ statistic ^ expected_statistic)) begin
                $display("PASS");
                $display("  Outputs: result=%h, statistic=%h",
                         result, statistic);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, statistic=%h",
                         expected_result, expected_statistic);
                $display("  Got:      result=%h, statistic=%h",
                         result, statistic);
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
        $dumpvars(0,ain, bin, clk, rst, result, statistic);
    end

endmodule
