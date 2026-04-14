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
            repeat(10) @(posedge sys_clk_i);
            sys_rst_i = 0;
            repeat(10) @(posedge sys_clk_i);
        end
        endtask
    task transmit_and_verify;

        input [7:0] data;
        input [9:0] expected_frame;
        reg [9:0] captured_frame;
        integer i;
        begin

            @(posedge sys_clk_i);
            uart_dat_i = data;
            uart_wr_i = 1;
            @(posedge sys_clk_i);
            #1 uart_wr_i = 0;


            wait(uart_busy === 1);
            wait(uart_tx === 0);


            repeat(HALF_BIT_PERIOD) @(posedge sys_clk_i);
            for (i = 0; i < 10; i = i + 1) begin
                captured_frame[i] = uart_tx;
                repeat(BIT_PERIOD_CYCLES) @(posedge sys_clk_i);
            end


            wait(uart_busy === 0);
            #500;


            if (captured_frame === expected_frame) begin
                $display("  Success: Transmitted 0x%h, Frame captured correctly: %b", data, captured_frame);
                #1;

                check_outputs(1'b0, 1'b1);
            end else begin
                $display("  Failure: Transmitted 0x%h, Expected frame %b, Got %b", data, expected_frame, captured_frame);
                #1;

                check_outputs(1'b0, 1'b0);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data 0x55", test_num);
            reset_dut();
            transmit_and_verify(8'h55, 10'b1010101010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data 0xAA", test_num);
            reset_dut();
            transmit_and_verify(8'hAA, 10'b1101010100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data 0x00", test_num);
            reset_dut();
            transmit_and_verify(8'h00, 10'b1000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data 0xFF", test_num);
            reset_dut();
            transmit_and_verify(8'hFF, 10'b1111111110);
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
