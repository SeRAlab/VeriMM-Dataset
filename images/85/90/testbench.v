`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg x;
    reg y;
    wire sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
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
            x = 0;
            y = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            x = 4'd0;
            y = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            x = 4'd5;
            y = 4'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            x = 4'd10;
            y = 4'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            x = 4'd8;
            y = 4'd8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            x = 4'd15;
            y = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            x = 4'd7;
            y = 4'd2;
            rst = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'd0);
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
        input expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%b",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%b",
                         expected_sum);
                $display("  Got:      sum=%b",
                         sum);
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
        $dumpvars(0,clk, rst, x, y, sum);
    end

endmodule
