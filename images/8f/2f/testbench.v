`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk2;
    reg count1;
    reg count2;
    wire [3:0] decenas1;
    wire [3:0] decenas2;
    wire [3:0] unidades1;
    wire [3:0] unidades2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk2(clk2),
        .count1(count1),
        .count2(count2),
        .decenas1(decenas1),
        .decenas2(decenas2),
        .unidades1(unidades1),
        .unidades2(unidades2)
    );

    // Clock generation (10ns period)
    initial begin
        clk2 = 0;
        forever #5 clk2 = ~clk2;
    end

        task reset_dut;

        begin
            count1 = 0;
            count2 = 0;


            repeat(2) @(negedge clk2);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Increment Counter 1 once");
            reset_dut();
            @(negedge clk2);
            count1 = 1;
            @(negedge clk2);
            count1 = 0;
            repeat(1) @(negedge clk2);
            #1;

            check_outputs(4'd0, 4'd0, 4'd1, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Increment Counter 2 five times");
            reset_dut();
            repeat(5) begin
                @(negedge clk2);
                count2 = 1;
            end
            @(negedge clk2);
            count2 = 0;
            repeat(1) @(negedge clk2);
            #1;

            check_outputs(4'd0, 4'd0, 4'd0, 4'd5);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Counter 1 roll over units (10 counts)");
            reset_dut();
            repeat(10) begin
                @(negedge clk2);
                count1 = 1;
            end
            @(negedge clk2);
            count1 = 0;
            repeat(1) @(negedge clk2);
            #1;

            check_outputs(4'd1, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Both counters incrementing 12 times");
            reset_dut();
            repeat(12) begin
                @(negedge clk2);
                count1 = 1;
                count2 = 1;
            end
            @(negedge clk2);
            count1 = 0;
            count2 = 0;
            repeat(1) @(negedge clk2);
            #1;

            check_outputs(4'd1, 4'd1, 4'd2, 4'd2);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Counter 2 reaching 99");
            reset_dut();
            repeat(99) begin
                @(negedge clk2);
                count2 = 1;
            end
            @(negedge clk2);
            count2 = 0;
            repeat(1) @(negedge clk2);
            #1;

            check_outputs(4'd0, 4'd9, 4'd0, 4'd9);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Counter 1 rolling over from 99 to 00");
            reset_dut();
            repeat(100) begin
                @(negedge clk2);
                count1 = 1;
            end
            @(negedge clk2);
            count1 = 0;
            repeat(1) @(negedge clk2);
            #1;

            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Intermittent counting (Check count enable)");
            reset_dut();
            repeat(3) begin
                @(negedge clk2) count1 = 1;
                @(negedge clk2) count1 = 0;
            end
            repeat(1) @(negedge clk2);
            #1;

            check_outputs(4'd0, 4'd0, 4'd3, 4'd0);
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
        input [3:0] expected_decenas1;
        input [3:0] expected_decenas2;
        input [3:0] expected_unidades1;
        input [3:0] expected_unidades2;
        begin
            if (expected_decenas1 === (expected_decenas1 ^ decenas1 ^ expected_decenas1) &&
                expected_decenas2 === (expected_decenas2 ^ decenas2 ^ expected_decenas2) &&
                expected_unidades1 === (expected_unidades1 ^ unidades1 ^ expected_unidades1) &&
                expected_unidades2 === (expected_unidades2 ^ unidades2 ^ expected_unidades2)) begin
                $display("PASS");
                $display("  Outputs: decenas1=%h, decenas2=%h, unidades1=%h, unidades2=%h",
                         decenas1, decenas2, unidades1, unidades2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decenas1=%h, decenas2=%h, unidades1=%h, unidades2=%h",
                         expected_decenas1, expected_decenas2, expected_unidades1, expected_unidades2);
                $display("  Got:      decenas1=%h, decenas2=%h, unidades1=%h, unidades2=%h",
                         decenas1, decenas2, unidades1, unidades2);
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
        $dumpvars(0,clk2, count1, count2, decenas1, decenas2, unidades1, unidades2);
    end

endmodule
