`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] col;
    reg [3:0] row;
    reg rst;
    wire [3:0] key;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .col(col),
        .row(row),
        .rst(rst),
        .key(key),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            row = 4'b0000;
            col = 4'b0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test 001: Reset Behavior Check");
            reset_dut();
            #1;

            check_outputs(4'h0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: Key 0 (Row 0, Col 0)");
            reset_dut();
            row = 4'b0001;
            col = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Key 5 (Row 1, Col 1)");
            reset_dut();
            row = 4'b0010;
            col = 4'b0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Key 11 (Row 2, Col 3)");
            reset_dut();
            row = 4'b0100;
            col = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hB, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Key 14 (Row 3, Col 2)");
            reset_dut();
            row = 4'b1000;
            col = 4'b0100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hE, 1);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: No key pressed check");
            reset_dut();
            row = 4'b0000;
            col = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(key, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: Key 15 (Row 3, Col 3)");
            reset_dut();
            row = 4'b1000;
            col = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 1);
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
        input [3:0] expected_key;
        input expected_valid;
        begin
            if (expected_key === (expected_key ^ key ^ expected_key) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: key=%h, valid=%b",
                         key, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key=%h, valid=%b",
                         expected_key, expected_valid);
                $display("  Got:      key=%h, valid=%b",
                         key, valid);
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
        $dumpvars(0,clk, col, row, rst, key, valid);
    end

endmodule
