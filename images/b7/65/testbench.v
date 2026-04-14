`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] ena;
    reg reset;
    wire [15:0] q;
    wire [3:0] sum_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena(ena),
        .reset(reset),
        .q(q),
        .sum_output(sum_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            ena = 3'b000;
            @(posedge clk);
            reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Increment Units to 5", test_num);
            reset_dut();
            ena = 3'b001;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0005, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rollover to Tens digit", test_num);
            reset_dut();
            ena = 3'b011;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'h0010, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Gating (ena[1]=0)", test_num);
            reset_dut();
            ena = 3'b001;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0000, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rollover to Hundreds", test_num);
            reset_dut();
            ena = 3'b111;
            repeat(100) @(posedge clk);
            #1;

            check_outputs(16'h0100, 4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Large count and Sum check (1234)", test_num);
            reset_dut();
            ena = 3'b111;
            repeat(1234) @(posedge clk);
            #1;

            check_outputs(16'h1234, 4'hA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sum truncation/overflow check (9990)", test_num);
            reset_dut();
            ena = 3'b111;
            repeat(9990) @(posedge clk);
            #1;

            check_outputs(16'h9990, 4'hB);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Rollover (9999 -> 0000)", test_num);
            reset_dut();
            ena = 3'b111;
            repeat(10000) @(posedge clk);
            #1;

            check_outputs(16'h0000, 4'h0);
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
        input [15:0] expected_q;
        input [3:0] expected_sum_output;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_sum_output === (expected_sum_output ^ sum_output ^ expected_sum_output)) begin
                $display("PASS");
                $display("  Outputs: q=%h, sum_output=%h",
                         q, sum_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, sum_output=%h",
                         expected_q, expected_sum_output);
                $display("  Got:      q=%h, sum_output=%h",
                         q, sum_output);
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
        $dumpvars(0,clk, ena, reset, q, sum_output);
    end

endmodule
