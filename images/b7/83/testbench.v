`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire ce_n;
    wire lb_n;
    wire oe_n;
    wire [19:0] sram_addr;
    wire ub_n;
    wire we_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .ce_n(ce_n),
        .lb_n(lb_n),
        .oe_n(oe_n),
        .sram_addr(sram_addr),
        .ub_n(ub_n),
        .we_n(we_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #2 rst = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 20'h00000, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: Counter incrementing (100 cycles)", test_num);
            reset_dut();
            repeat(100) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 20'h00064, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: Boundary condition (0xFFFFE)", test_num);
            reset_dut();

            repeat(20'hffffe) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 20'hffffe, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase%03d: Trigger active at 0xFFFFF", test_num);
            reset_dut();

            repeat(20'hfffff) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 20'hfffff, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase%03d: Wrap around behavior", test_num);
            reset_dut();

            repeat(20'h100000) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 20'h00000, 1'b0, 1'b1);
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
        input expected_ce_n;
        input expected_lb_n;
        input expected_oe_n;
        input [19:0] expected_sram_addr;
        input expected_ub_n;
        input expected_we_n;
        begin
            if (expected_ce_n === (expected_ce_n ^ ce_n ^ expected_ce_n) &&
                expected_lb_n === (expected_lb_n ^ lb_n ^ expected_lb_n) &&
                expected_oe_n === (expected_oe_n ^ oe_n ^ expected_oe_n) &&
                expected_sram_addr === (expected_sram_addr ^ sram_addr ^ expected_sram_addr) &&
                expected_ub_n === (expected_ub_n ^ ub_n ^ expected_ub_n) &&
                expected_we_n === (expected_we_n ^ we_n ^ expected_we_n)) begin
                $display("PASS");
                $display("  Outputs: ce_n=%b, lb_n=%b, oe_n=%b, sram_addr=%h, ub_n=%b, we_n=%b",
                         ce_n, lb_n, oe_n, sram_addr, ub_n, we_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ce_n=%b, lb_n=%b, oe_n=%b, sram_addr=%h, ub_n=%b, we_n=%b",
                         expected_ce_n, expected_lb_n, expected_oe_n, expected_sram_addr, expected_ub_n, expected_we_n);
                $display("  Got:      ce_n=%b, lb_n=%b, oe_n=%b, sram_addr=%h, ub_n=%b, we_n=%b",
                         ce_n, lb_n, oe_n, sram_addr, ub_n, we_n);
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
        $dumpvars(0,clk, rst, ce_n, lb_n, oe_n, sram_addr, ub_n, we_n);
    end

endmodule
