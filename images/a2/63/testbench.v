`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg count_dir;
    reg dual_count;
    reg enable;
    reg rst;
    wire [7:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count_dir(count_dir),
        .dual_count(dual_count),
        .enable(enable),
        .rst(rst),
        .count_out(count_out)
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
            count_dir = 0;
            dual_count = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            enable = 1;
            count_dir = 1;
            dual_count = 0;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            enable = 1;
            count_dir = 0;
            dual_count = 0;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            enable = 1;
            count_dir = 1;
            dual_count = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            enable = 1;
            count_dir = 0;
            dual_count = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'hFC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            enable = 0;
            count_dir = 1;
            dual_count = 0;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            enable = 1;
            count_dir = 1;
            dual_count = 0;
            repeat(256) @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            enable = 1;
            count_dir = 1;
            dual_count = 1;
            repeat(128) @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            enable = 1;
            count_dir = 1;
            dual_count = 0;
            repeat(10) @(posedge clk);
            count_dir = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'd5);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            enable = 1;
            count_dir = 1;
            dual_count = 0;
            repeat(10) @(posedge clk);
            dual_count = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'd20);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            enable = 1;
            count_dir = 1; dual_count = 1; repeat(10) @(posedge clk);
            count_dir = 0; dual_count = 0; repeat(5) @(posedge clk);
            enable = 0; repeat(10) @(posedge clk);
            enable = 1; count_dir = 1; dual_count = 0; repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'd17);
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
        input [7:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,clk, count_dir, dual_count, enable, rst, count_out);
    end

endmodule
