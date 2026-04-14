`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ser_clk;
    reg sys_rst_i;
    reg [7:0] uart_dat_i;
    reg uart_wr_i;
    wire uart_busy;
    wire uart_rts;
    wire uart_tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ser_clk(ser_clk),
        .sys_rst_i(sys_rst_i),
        .uart_dat_i(uart_dat_i),
        .uart_wr_i(uart_wr_i),
        .uart_busy(uart_busy),
        .uart_rts(uart_rts),
        .uart_tx(uart_tx)
    );

    // Clock generation (10ns period)
    initial begin
        ser_clk = 0;
        forever #5 ser_clk = ~ser_clk;
    end

        task reset_dut;

        begin
            sys_rst_i = 1;
            uart_wr_i = 0;
            uart_dat_i = 8'h00;
            repeat(2) @(posedge ser_clk);
            #1;
            sys_rst_i = 0;
            @(posedge ser_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            uart_dat_i = 8'h00;
            uart_wr_i = 1;
            @(posedge ser_clk);
            #1;
            uart_wr_i = 0;

            repeat(12) @(posedge ser_clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            uart_dat_i = 8'hFF;
            uart_wr_i = 1;
            @(posedge ser_clk);
            #1;
            uart_wr_i = 0;
            repeat(12) @(posedge ser_clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            uart_dat_i = 8'h55;
            uart_wr_i = 1;
            @(posedge ser_clk);
            #1;
            uart_wr_i = 0;
            repeat(12) @(posedge ser_clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            uart_dat_i = 8'hAA;
            uart_wr_i = 1;
            @(posedge ser_clk);
            #1;
            uart_wr_i = 0;
            repeat(12) @(posedge ser_clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_uart_busy;
        input expected_uart_rts;
        input expected_uart_tx;
        begin
            if (expected_uart_busy === (expected_uart_busy ^ uart_busy ^ expected_uart_busy) &&
                expected_uart_rts === (expected_uart_rts ^ uart_rts ^ expected_uart_rts) &&
                expected_uart_tx === (expected_uart_tx ^ uart_tx ^ expected_uart_tx)) begin
                $display("PASS");
                $display("  Outputs: uart_busy=%b, uart_rts=%b, uart_tx=%b",
                         uart_busy, uart_rts, uart_tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: uart_busy=%b, uart_rts=%b, uart_tx=%b",
                         expected_uart_busy, expected_uart_rts, expected_uart_tx);
                $display("  Got:      uart_busy=%b, uart_rts=%b, uart_tx=%b",
                         uart_busy, uart_rts, uart_tx);
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
        $dumpvars(0,ser_clk, sys_rst_i, uart_dat_i, uart_wr_i, uart_busy, uart_rts, uart_tx);
    end

endmodule
