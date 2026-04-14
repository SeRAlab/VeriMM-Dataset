`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce_16;
    reg clock;
    reg reset;
    reg ser_in;
    wire new_rx_data;
    wire [7:0] rx_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce_16(ce_16),
        .clock(clock),
        .reset(reset),
        .ser_in(ser_in),
        .new_rx_data(new_rx_data),
        .rx_data(rx_data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            ce_16 = 0;
            ser_in = 1;
            repeat(5) @(posedge clock);
            reset = 0;
            repeat(2) @(posedge clock);
        end
        endtask
    task pulse_ce_16;

        begin
            @(posedge clock);
            ce_16 = 1;
            @(posedge clock);
            ce_16 = 0;

            repeat(2) @(posedge clock);
        end
        endtask

    task send_uart_byte;

        input [7:0] data;
        integer bit_idx, pulse_idx;
        begin

            ser_in = 0;
            repeat(16) pulse_ce_16();


            for (bit_idx = 0; bit_idx < 8; bit_idx = bit_idx + 1) begin
                ser_in = data[bit_idx];
                repeat(16) pulse_ce_16();
            end


            ser_in = 1;
            repeat(16) pulse_ce_16();


            repeat(5) @(posedge clock);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sending 0x55", test_num);
            reset_dut();
            send_uart_byte(8'h55);
            #1;

            check_outputs(1'b1, 8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sending 0xAA", test_num);
            reset_dut();
            send_uart_byte(8'hAA);
            #1;

            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sending 0x00", test_num);
            reset_dut();
            send_uart_byte(8'h00);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sending 0xFF", test_num);
            reset_dut();
            send_uart_byte(8'hFF);
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sending 0xC3", test_num);
            reset_dut();
            send_uart_byte(8'hC3);
            #1;

            check_outputs(1'b1, 8'hC3);
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
        input expected_new_rx_data;
        input [7:0] expected_rx_data;
        begin
            if (expected_new_rx_data === (expected_new_rx_data ^ new_rx_data ^ expected_new_rx_data) &&
                expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data)) begin
                $display("PASS");
                $display("  Outputs: new_rx_data=%b, rx_data=%h",
                         new_rx_data, rx_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_rx_data=%b, rx_data=%h",
                         expected_new_rx_data, expected_rx_data);
                $display("  Got:      new_rx_data=%b, rx_data=%h",
                         new_rx_data, rx_data);
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
        $dumpvars(0,ce_16, clock, reset, ser_in, new_rx_data, rx_data);
    end

endmodule
