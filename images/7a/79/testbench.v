`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [7:0] din;
    reg gate;
    wire all_ones;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .din(din),
        .gate(gate),
        .all_ones(all_ones),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            clear = 1;
            gate = 0;
            din = 8'h00;
            @(posedge clk);
            clear = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Post-Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Addition", test_num);
            reset_dut();
            @(posedge clk);
            gate = 1;
            din = 8'h12;
            @(posedge clk);
            gate = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 8'hED);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Gate Control Logic", test_num);
            reset_dut();
            @(posedge clk);
            gate = 1;
            din = 8'h05;
            @(posedge clk);
            gate = 0;
            din = 8'hAA;
            @(posedge clk);
            gate = 1;
            din = 8'h00;
            @(posedge clk);
            gate = 0;
            #1;

            check_outputs(1'b0, 8'hFA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Modular Overflow Wrap", test_num);
            reset_dut();
            @(posedge clk);
            gate = 1;
            din = 8'hFE;
            @(posedge clk);
            din = 8'h03;
            @(posedge clk);
            gate = 0;
            #1;

            check_outputs(1'b0, 8'hFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Result", test_num);
            reset_dut();
            @(posedge clk);
            gate = 1;
            din = 8'h80;
            @(posedge clk);
            din = 8'h80;
            @(posedge clk);
            gate = 0;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Accumulation", test_num);
            reset_dut();
            @(posedge clk);
            gate = 1;
            din = 8'h01; @(posedge clk);
            din = 8'h02; @(posedge clk);
            din = 8'h03; @(posedge clk);
            din = 8'h04; @(posedge clk);
            gate = 0;
            #1;

            check_outputs(1'b0, 8'hF5);
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
        input expected_all_ones;
        input [7:0] expected_sum;
        begin
            if (expected_all_ones === (expected_all_ones ^ all_ones ^ expected_all_ones) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: all_ones=%b, sum=%h",
                         all_ones, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: all_ones=%b, sum=%h",
                         expected_all_ones, expected_sum);
                $display("  Got:      all_ones=%b, sum=%h",
                         all_ones, sum);
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
        $dumpvars(0,clear, clk, din, gate, all_ones, sum);
    end

endmodule
