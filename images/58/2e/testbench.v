`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg enable_i;
    reg rst_i;
    reg [15:0] uart_brr_i;
    wire baud_clk_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .enable_i(enable_i),
        .rst_i(rst_i),
        .uart_brr_i(uart_brr_i),
        .baud_clk_o(baud_clk_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            enable_i = 0;
            uart_brr_i = 0;
            repeat(2) @(posedge clk_i);
            #1 rst_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic functional check (BRR=5)", test_num);
            uart_brr_i = 16'd5;
            enable_i = 1;


            repeat(5) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Check output before reaching BRR (BRR=10, checking at 5)", test_num);
            uart_brr_i = 16'd10;
            enable_i = 1;


            repeat(5) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Enable signal check (BRR=5, enable=0)", test_num);
            uart_brr_i = 16'd5;
            enable_i = 0;

            repeat(10) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Functional check with different BRR (BRR=12)", test_num);
            uart_brr_i = 16'd12;
            enable_i = 1;

            repeat(12) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Reset signal mid-count check", test_num);
            uart_brr_i = 16'd10;
            enable_i = 1;


            repeat(5) @(posedge clk_i);
            rst_i = 1;
            repeat(2) @(posedge clk_i);
            rst_i = 0;


            repeat(5) @(posedge clk_i);
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
        input expected_baud_clk_o;
        begin
            if (expected_baud_clk_o === (expected_baud_clk_o ^ baud_clk_o ^ expected_baud_clk_o)) begin
                $display("PASS");
                $display("  Outputs: baud_clk_o=%b",
                         baud_clk_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: baud_clk_o=%b",
                         expected_baud_clk_o);
                $display("  Got:      baud_clk_o=%b",
                         baud_clk_o);
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
        $dumpvars(0,clk_i, enable_i, rst_i, uart_brr_i, baud_clk_o);
    end

endmodule
