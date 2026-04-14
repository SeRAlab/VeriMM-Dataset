`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg clk;
    reg [3:0] d;
    reg rst;
    reg start;
    wire [3:0] qout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clk(clk),
        .d(d),
        .rst(rst),
        .start(start),
        .qout(qout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            d = 0;
            D = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive / Positive (6 / 2)", test_num);
            reset_dut();
            D = 4'sd6;
            d = 4'sd2;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(4'sd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive / Negative (6 / -2)", test_num);
            reset_dut();
            D = 4'sd6;
            d = -4'sd2;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(-4'sd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative / Positive (-6 / 2)", test_num);
            reset_dut();
            D = -4'sd6;
            d = 4'sd2;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(-4'sd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative / Negative (-6 / -2)", test_num);
            reset_dut();
            D = -4'sd6;
            d = -4'sd2;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(4'sd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Dividend (0 / 5)", test_num);
            reset_dut();
            D = 4'sd0;
            d = 4'sd5;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(4'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division with Truncation (7 / 3)", test_num);
            reset_dut();
            D = 4'sd7;
            d = 4'sd3;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(4'sd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min Value Division (-8 / 4)", test_num);
            reset_dut();
            D = -4'sd8;
            d = 4'sd4;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(-4'sd2);
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
        input [3:0] expected_qout;
        begin
            if (expected_qout === (expected_qout ^ qout ^ expected_qout)) begin
                $display("PASS");
                $display("  Outputs: qout=%h",
                         qout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qout=%h",
                         expected_qout);
                $display("  Got:      qout=%h",
                         qout);
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
        $dumpvars(0,D, clk, d, rst, start, qout);
    end

endmodule
