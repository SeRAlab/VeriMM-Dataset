`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg sys_clk_i;
    reg sys_rst_i;
    reg [7:0] uart_dat_i;
    reg uart_wr_i;
    wire uart_busy;
    wire uart_tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sys_clk_i(sys_clk_i),
        .sys_rst_i(sys_rst_i),
        .uart_dat_i(uart_dat_i),
        .uart_wr_i(uart_wr_i),
        .uart_busy(uart_busy),
        .uart_tx(uart_tx)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk_i = 0;
        forever #5 sys_clk_i = ~sys_clk_i;
    end

        task reset_dut;

        begin
            sys_rst_i = 1;
            uart_wr_i = 0;
            uart_dat_i = 8'h00;
            repeat(5) @(posedge sys_clk_i);
            sys_rst_i = 0;
            repeat(5) @(posedge sys_clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transmitting 0x55 (Alternating bits)", test_num);
            reset_dut();

            uart_dat_i = 8'h55;
            @(posedge sys_clk_i);
            uart_wr_i = 1;
            @(posedge sys_clk_i);
            uart_wr_i = 0;


            #(11 * BIT_PERIOD);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transmitting 0xAA", test_num);
            reset_dut();

            uart_dat_i = 8'hAA;
            @(posedge sys_clk_i);
            uart_wr_i = 1;
            @(posedge sys_clk_i);
            uart_wr_i = 0;

            #(11 * BIT_PERIOD);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transmitting 0xFF (All High Data)", test_num);
            reset_dut();

            uart_dat_i = 8'hFF;
            @(posedge sys_clk_i);
            uart_wr_i = 1;
            @(posedge sys_clk_i);
            uart_wr_i = 0;

            #(11 * BIT_PERIOD);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transmitting 0x00 (All Low Data)", test_num);
            reset_dut();

            uart_dat_i = 8'h00;
            @(posedge sys_clk_i);
            uart_wr_i = 1;
            @(posedge sys_clk_i);
            uart_wr_i = 0;

            #(11 * BIT_PERIOD);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify uart_busy asserts immediately", test_num);
            reset_dut();

            uart_dat_i = 8'h12;
            @(posedge sys_clk_i);
            uart_wr_i = 1;
            @(posedge sys_clk_i);
            uart_wr_i = 0;


            #100;
            if (uart_busy === 1'b1) begin
                $display("PASS: Busy signal asserted correctly");
            end else begin
                $display("FAIL: Busy signal failed to assert");
            end


            #(11 * BIT_PERIOD);
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_uart_tx;
        begin
            if (expected_uart_busy === (expected_uart_busy ^ uart_busy ^ expected_uart_busy) &&
                expected_uart_tx === (expected_uart_tx ^ uart_tx ^ expected_uart_tx)) begin
                $display("PASS");
                $display("  Outputs: uart_busy=%b, uart_tx=%b",
                         uart_busy, uart_tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: uart_busy=%b, uart_tx=%b",
                         expected_uart_busy, expected_uart_tx);
                $display("  Got:      uart_busy=%b, uart_tx=%b",
                         uart_busy, uart_tx);
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
        $dumpvars(0,sys_clk_i, sys_rst_i, uart_dat_i, uart_wr_i, uart_busy, uart_tx);
    end

endmodule
