`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d1;
    reg [7:0] d2;
    reg rst;
    reg sel;
    wire [7:0] q;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d1(d1),
        .d2(d2),
        .rst(rst),
        .sel(sel),
        .q(q),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            d1 = 0;
            d2 = 0;
            sel = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            d1 = 8'h12;
            d2 = 8'h34;
            rst = 1;
            #5;
            #1;

            check_outputs(8'h00, 8'h46);
            rst = 0;
            #5;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            d1 = 8'hA5;
            d2 = 8'h5A;
            sel = 0;
            @(negedge clk);
            #2;
            #1;

            check_outputs(8'hA5, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            d1 = 8'h11;
            d2 = 8'h22;
            sel = 1;
            @(negedge clk);
            #2;
            #1;

            check_outputs(8'h22, 8'h33);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            d1 = 8'h10;
            d2 = 8'h20;
            sel = 0;
            @(negedge clk);
            #2;

            d1 = 8'h30;
            d2 = 8'h40;
            #2;
            #1;

            check_outputs(8'h10, 8'h70);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            d1 = 8'hFF;
            d2 = 8'h01;
            sel = 1;
            @(negedge clk);
            #2;
            #1;

            check_outputs(8'h01, 8'h00);
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
        input [7:0] expected_q;
        input [7:0] expected_sum;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: q=%h, sum=%h",
                         q, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, sum=%h",
                         expected_q, expected_sum);
                $display("  Got:      q=%h, sum=%h",
                         q, sum);
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
        $dumpvars(0,clk, d1, d2, rst, sel, q, sum);
    end

endmodule
