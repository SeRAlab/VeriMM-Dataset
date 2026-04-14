`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg reset;
    reg select;
    wire [7:0] sum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .reset(reset),
        .select(select),
        .sum_out(sum_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in1 = 0;
            data_in2 = 0;
            select = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data_in1, Counter=0", test_num);
            reset_dut();
            data_in1 = 8'h15;
            data_in2 = 8'hA0;
            select = 0;
            #1;
            #1;

            check_outputs(8'h15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data_in2, Counter=0", test_num);
            reset_dut();
            data_in1 = 8'h15;
            data_in2 = 8'hA0;
            select = 1;
            #1;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data_in1, Counter=5", test_num);
            reset_dut();
            data_in1 = 8'd100;
            data_in2 = 8'd200;
            select = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data_in2, Counter=10", test_num);
            reset_dut();
            data_in1 = 8'd50;
            data_in2 = 8'd50;
            select = 1;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd70);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum Overflow Test", test_num);
            reset_dut();
            data_in1 = 8'd250;
            select = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Counter Value Test", test_num);
            reset_dut();
            data_in1 = 8'd10;
            select = 0;
            repeat(128) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd10);
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
        input [7:0] expected_sum_out;
        begin
            if (expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out)) begin
                $display("PASS");
                $display("  Outputs: sum_out=%h",
                         sum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum_out=%h",
                         expected_sum_out);
                $display("  Got:      sum_out=%h",
                         sum_out);
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
        $dumpvars(0,clk, data_in1, data_in2, reset, select, sum_out);
    end

endmodule
