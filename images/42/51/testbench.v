`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [15:0] div;
    reg rst;
    wire clk_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .div(div),
        .rst(rst),
        .clk_o(clk_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst = 1;
            div = 0;
            @(posedge clk_i);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: div=1 (Toggle every cycle)", test_num);
            reset_dut();
            div = 16'h0001;
            repeat(3) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: div=2 (Toggle every 2 cycles)", test_num);
            reset_dut();
            div = 16'h0002;
            repeat(4) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: div=5 (Toggle every 5 cycles)", test_num);
            reset_dut();
            div = 16'h0005;
            repeat(15) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: div=100 (Check toggle at boundary)", test_num);
            reset_dut();
            div = 16'h0064;
            repeat(100) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: div=500 (Multi-toggle check)", test_num);
            reset_dut();
            div = 16'd500;
            repeat(1001) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_clk_o;
        begin
            if (expected_clk_o === (expected_clk_o ^ clk_o ^ expected_clk_o)) begin
                $display("PASS");
                $display("  Outputs: clk_o=%b",
                         clk_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_o=%b",
                         expected_clk_o);
                $display("  Got:      clk_o=%b",
                         clk_o);
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
        $dumpvars(0,clk_i, div, rst, clk_o);
    end

endmodule
