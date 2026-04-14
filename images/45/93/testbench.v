`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] bv;
    reg bv_valid;
    reg clk;
    reg [5:0] count;
    reg reset;
    wire [63:0] bv_out;
    wire bv_out_valid;
    wire [5:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bv(bv),
        .bv_valid(bv_valid),
        .clk(clk),
        .count(count),
        .reset(reset),
        .bv_out(bv_out),
        .bv_out_valid(bv_out_valid),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            bv = 64'b0;
            bv_valid = 0;
            count = 6'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: bv_valid = 0", test_num);
            bv = 64'hFFFFFFFFFFFFFFFF;
            bv_valid = 0;
            count = 6'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'd0, 1'b0, 6'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: LSB set (No Shift)", test_num);
            bv = 64'hA5A5A5A5A5A5A5A1;
            bv_valid = 1;
            count = 6'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hA5A5A5A5A5A5A5A1, 1'b1, 6'd5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: LSB clear (Shift Right by %0d)", test_num, RANGE_END);
            bv = 64'h1234567800000000;
            bv_valid = 1;
            count = 6'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs((64'h1234567800000000 >> RANGE_END), 1'b1, (6'd0 + RANGE_END));
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Offset count with Shift", test_num);
            bv = 64'h8888888800000000;
            bv_valid = 1;
            count = 6'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs((64'h8888888800000000 >> RANGE_END), 1'b1, (6'd4 + RANGE_END));
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            bv = 64'h1;
            bv_valid = 1;
            count = 6'd20;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(64'd0, 1'b0, 6'd0);
            reset = 0;
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
        input [63:0] expected_bv_out;
        input expected_bv_out_valid;
        input [5:0] expected_count_out;
        begin
            if (expected_bv_out === (expected_bv_out ^ bv_out ^ expected_bv_out) &&
                expected_bv_out_valid === (expected_bv_out_valid ^ bv_out_valid ^ expected_bv_out_valid) &&
                expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: bv_out=%h, bv_out_valid=%b, count_out=%h",
                         bv_out, bv_out_valid, count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bv_out=%h, bv_out_valid=%b, count_out=%h",
                         expected_bv_out, expected_bv_out_valid, expected_count_out);
                $display("  Got:      bv_out=%h, bv_out_valid=%b, count_out=%h",
                         bv_out, bv_out_valid, count_out);
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
        $dumpvars(0,bv, bv_valid, clk, count, reset, bv_out, bv_out_valid, count_out);
    end

endmodule
