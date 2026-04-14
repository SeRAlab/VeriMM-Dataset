`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [3:0] count_i;
    reg reset_i;
    wire [3:0] count_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .count_i(count_i),
        .reset_i(reset_i),
        .count_o(count_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            reset_i = 1;
            count_i = 4'b0000;
            @(posedge clk_i);
            #1;
            reset_i = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Count to 5", test_num);
            reset_dut();
            repeat(5) @(posedge clk_i);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Count to 15", test_num);
            reset_dut();
            repeat(15) @(posedge clk_i);
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Wrap-around check (16 cycles)", test_num);
            reset_dut();
            repeat(16) @(posedge clk_i);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();
            repeat(8) @(posedge clk_i);

            reset_i = 1;
            @(posedge clk_i);
            #1;
            reset_i = 0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Multiple wrap-arounds (33 cycles)", test_num);
            reset_dut();
            repeat(33) @(posedge clk_i);
            #1;
            #1;

            check_outputs(4'd1);
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
        input [3:0] expected_count_o;
        begin
            if (expected_count_o === (expected_count_o ^ count_o ^ expected_count_o)) begin
                $display("PASS");
                $display("  Outputs: count_o=%h",
                         count_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_o=%h",
                         expected_count_o);
                $display("  Got:      count_o=%h",
                         count_o);
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
        $dumpvars(0,clk_i, count_i, reset_i, count_o);
    end

endmodule
