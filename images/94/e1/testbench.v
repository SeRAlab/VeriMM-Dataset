`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg UART_RX;
    reg clk;
    wire [7:0] data;
    wire send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .UART_RX(UART_RX),
        .clk(clk),
        .data(data),
        .send(send)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            UART_RX = 1;
            test_num = test_num + 1;
            repeat(5) @(posedge clk);
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

            #(CLK_PERIOD);
        end
        endtask

    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            send_uart_byte(8'h55);

            #1;


            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            send_uart_byte(8'hAA);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            send_uart_byte(8'h00);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            send_uart_byte(8'hFF);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            send_uart_byte(8'hA1);

            send_uart_byte(8'h12);

            #1;


            check_outputs(8'h12, 1'b1);
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
        input [7:0] expected_data;
        input expected_send;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_send === (expected_send ^ send ^ expected_send)) begin
                $display("PASS");
                $display("  Outputs: data=%h, send=%b",
                         data, send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, send=%b",
                         expected_data, expected_send);
                $display("  Got:      data=%h, send=%b",
                         data, send);
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
        $dumpvars(0,UART_RX, clk, data, send);
    end

endmodule
