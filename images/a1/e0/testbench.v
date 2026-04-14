`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg rst_i;
    reg rx_i;
    wire [7:0] led_o;
    wire tx_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .rx_i(rx_i),
        .led_o(led_o),
        .tx_o(tx_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            rx_i = 1;
            repeat (5) @(posedge clk_i);
            rst_i = 0;
            repeat (5) @(posedge clk_i);
        end
        endtask
    task send_uart_byte;

        input [7:0] data;
        integer i;
        begin

            rx_i = 0;
            repeat (CLKS_PER_BIT) @(posedge clk_i);


            for (i = 0; i < 8; i = i + 1) begin
                rx_i = data[i];
                repeat (CLKS_PER_BIT) @(posedge clk_i);
            end


            rx_i = 1;
            repeat (CLKS_PER_BIT) @(posedge clk_i);


            repeat (5) @(posedge clk_i);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            send_uart_byte(8'h55);


            #1;



            check_outputs(8'h55, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            send_uart_byte(8'hAA);
            #1;

            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            send_uart_byte(8'hFF);
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            send_uart_byte(8'h00);
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            send_uart_byte(8'h12);
            send_uart_byte(8'h34);
            #1;

            check_outputs(8'h34, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            send_uart_byte(8'hA5);

            if (led_o == 8'hA5) begin

                rst_i = 1;
                repeat (5) @(posedge clk_i);
                rst_i = 0;
                #1;

                check_outputs(8'h00, 1'b0);
            end else begin
                $display("Pre-reset check failed in testcase006");
                fail_count = fail_count + 1;
            end
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
        input [7:0] expected_led_o;
        input expected_tx_o;
        begin
            if (expected_led_o === (expected_led_o ^ led_o ^ expected_led_o) &&
                expected_tx_o === (expected_tx_o ^ tx_o ^ expected_tx_o)) begin
                $display("PASS");
                $display("  Outputs: led_o=%h, tx_o=%b",
                         led_o, tx_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_o=%h, tx_o=%b",
                         expected_led_o, expected_tx_o);
                $display("  Got:      led_o=%h, tx_o=%b",
                         led_o, tx_o);
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
        $dumpvars(0,clk_i, rst_i, rx_i, led_o, tx_o);
    end

endmodule
