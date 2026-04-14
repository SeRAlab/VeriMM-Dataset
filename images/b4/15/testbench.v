`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Checking forced zero state (rst=0)...", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            rst = 1;
            @(posedge clk); #1;
            $display("Test %0d: Checking first sequence value (1)...", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            rst = 1;
            repeat(2) @(posedge clk); #1;
            $display("Test %0d: Checking second sequence value (3)...", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            rst = 1;
            repeat(4) @(posedge clk); #1;
            $display("Test %0d: Checking fourth sequence value (9)...", test_num);
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            rst = 1;
            repeat(7) @(posedge clk); #1;
            $display("Test %0d: Checking seventh sequence value (14)...", test_num);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            rst = 1;
            repeat(8) @(posedge clk); #1;
            $display("Test %0d: Checking eighth sequence value (loop to 0)...", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            rst = 1;
            repeat(9) @(posedge clk); #1;
            $display("Test %0d: Checking sequence loop-back start (1)...", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            rst = 1;
            repeat(3) @(posedge clk);
            rst = 0;
            @(posedge clk); #1;
            $display("Test %0d: Interrupting sequence with rst=0, checking for 0...", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            rst = 1;
            repeat(6) @(posedge clk); #1;
            $display("Test %0d: Checking sixth sequence value (13)...", test_num);
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            rst = 1;
            repeat(8) @(posedge clk);
            repeat(1) @(posedge clk);
            rst = 0;
            #1;
            $display("Test %0d: Forced zero after loop...", test_num);
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, rst, q);
    end

endmodule
