`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg UART_RX;
    reg clk;
    wire [7:0] data;
    wire insend;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .UART_RX(UART_RX),
        .clk(clk),
        .data(data),
        .insend(insend)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            UART_RX = 1;
            repeat(20) @(posedge clk);
        end
        endtask
    task send_uart_byte;

        input [7:0] byte_to_send;
        integer i;
        begin

            UART_RX = 0;
            #(BIT_PERIOD);


            for (i = 0; i < 8; i = i + 1) begin
                UART_RX = byte_to_send[i];
                #(BIT_PERIOD);
            end


            UART_RX = 1;
            #(BIT_PERIOD);


            #(BIT_PERIOD);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Valid Packet (Addr=0x11, Data=0x22, Checksum=0x33)");

            send_uart_byte(8'h11);
            send_uart_byte(8'h22);
            send_uart_byte(8'h33);


            #(BIT_PERIOD * 2);
            #1;

            check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Valid Packet with Wrap-around Checksum (Addr=0xFF, Data=0x01, Checksum=0x00)");

            send_uart_byte(8'hFF);
            send_uart_byte(8'h01);
            send_uart_byte(8'h00);

            #(BIT_PERIOD * 2);
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Invalid Packet - Checksum Mismatch");

            send_uart_byte(8'h10);
            send_uart_byte(8'h20);
            send_uart_byte(8'hFF);

            #(BIT_PERIOD * 2);


            #1;



            check_outputs(data, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: All Zeros Valid Packet");

            send_uart_byte(8'h00);
            send_uart_byte(8'h00);
            send_uart_byte(8'h00);

            #(BIT_PERIOD * 2);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Consecutive Packets");


            send_uart_byte(8'h05);
            send_uart_byte(8'h0A);
            send_uart_byte(8'h0F);
            #(BIT_PERIOD * 2);


            send_uart_byte(8'h20);
            send_uart_byte(8'h45);
            send_uart_byte(8'h65);

            #(BIT_PERIOD * 2);
            #1;

            check_outputs(8'h45, 1'b1);
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
        input expected_insend;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_insend === (expected_insend ^ insend ^ expected_insend)) begin
                $display("PASS");
                $display("  Outputs: data=%h, insend=%b",
                         data, insend);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, insend=%b",
                         expected_data, expected_insend);
                $display("  Got:      data=%h, insend=%b",
                         data, insend);
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
        $dumpvars(0,UART_RX, clk, data, insend);
    end

endmodule
