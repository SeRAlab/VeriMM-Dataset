`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input1;
    reg [3:0] input2;
    reg reset;
    wire [3:0] counter_out;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input1(input1),
        .input2(input2),
        .reset(reset),
        .counter_out(counter_out),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input1 = 0;
            input2 = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            input1 = 4'd5;
            input2 = 4'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 4'd5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            input1 = 4'd2;
            input2 = 4'd7;
            @(posedge clk);

            #1;
            input1 = 4'd4;
            input2 = 4'd1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd2, 4'd11);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            input1 = 0;
            input2 = 0;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            input1 = 0;
            input2 = 4'd10;
            @(posedge clk);
            #1;

            input1 = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 4'd4);
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
        input [3:0] expected_counter_out;
        input [3:0] expected_sum;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, sum=%h",
                         counter_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, sum=%h",
                         expected_counter_out, expected_sum);
                $display("  Got:      counter_out=%h, sum=%h",
                         counter_out, sum);
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
        $dumpvars(0,clk, input1, input2, reset, counter_out, sum);
    end

endmodule
