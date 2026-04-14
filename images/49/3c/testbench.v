`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg rx;
    reg rx_error;
    reg rx_valid;
    wire [7:0] data;
    wire data_valid;
    wire framing_error;
    wire parity_error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_error(rx_error),
        .rx_valid(rx_valid),
        .data(data),
        .data_valid(data_valid),
        .framing_error(framing_error),
        .parity_error(parity_error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rx = 1;
            rx_error = 0;
            rx_valid = 0;
            #20;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task send_uart_frame;

        input [7:0] d;
        input p;
        input stop_bit;
        integer i;
        begin
            rx_valid = 1;

            rx = 0;
            @(posedge clk);

            for (i = 0; i < 8; i = i + 1) begin
                rx = d[i];
                @(posedge clk);
            end

            rx = p;
            @(posedge clk);

            rx = stop_bit;
            @(posedge clk);

            rx = 1;
            rx_valid = 0;
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Data 0x55", test_num);
            reset_dut();
            send_uart_frame(8'h55, 1'b0, 1'b1);
            #1;

            check_outputs(8'h55, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Data 0xA5", test_num);
            reset_dut();
            send_uart_frame(8'hA5, 1'b0, 1'b1);
            #1;

            check_outputs(8'hA5, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Parity Error (Data 0xFF, Incorrect Parity)", test_num);
            reset_dut();
            send_uart_frame(8'hFF, 1'b1, 1'b1);

            #1;


            check_outputs(data, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Framing Error (Stop bit 0)", test_num);
            reset_dut();
            send_uart_frame(8'hAA, 1'b0, 1'b0);
            #1;

            check_outputs(data, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Mid-Transmission", test_num);
            reset_dut();

            rx = 0; @(posedge clk);
            rx = 1; @(posedge clk);
            rst = 1; @(posedge clk);
            rst = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b0, 1'b0);
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
        input [7:0] expected_data;
        input expected_data_valid;
        input expected_framing_error;
        input expected_parity_error;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid) &&
                expected_framing_error === (expected_framing_error ^ framing_error ^ expected_framing_error) &&
                expected_parity_error === (expected_parity_error ^ parity_error ^ expected_parity_error)) begin
                $display("PASS");
                $display("  Outputs: data=%h, data_valid=%b, framing_error=%b, parity_error=%b",
                         data, data_valid, framing_error, parity_error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, data_valid=%b, framing_error=%b, parity_error=%b",
                         expected_data, expected_data_valid, expected_framing_error, expected_parity_error);
                $display("  Got:      data=%h, data_valid=%b, framing_error=%b, parity_error=%b",
                         data, data_valid, framing_error, parity_error);
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
        $dumpvars(0,clk, rst, rx, rx_error, rx_valid, data, data_valid, framing_error, parity_error);
    end

endmodule
