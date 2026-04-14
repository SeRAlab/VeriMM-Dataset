`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire data_out;
    wire data_ready;
    wire rx_en;
    wire tx_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .data_ready(data_ready),
        .rx_en(rx_en),
        .tx_en(tx_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 1;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin

            data_in = 0;
            #10;

            for (i = 0; i < 8; i = i + 1) begin
                data_in = data[i];
                #10;
            end

            data_in = 1;
            #10;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Detecting start bit and entering RECEIVE state");
            reset_dut();


            data_in = 0;
            #10;

            data_in = 1;
            #10;



            #1;




            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Verifying TRANSMIT start after full reception (Data: 0x55)");
            reset_dut();


            send_byte(8'h55);


            #10;



            #1;




            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Verifying transmission completion and return to IDLE (Data: 0xAA)");
            reset_dut();


            send_byte(8'hAA);



            #120;



            #1;




            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
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
        input expected_data_out;
        input expected_data_ready;
        input expected_rx_en;
        input expected_tx_en;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_rx_en === (expected_rx_en ^ rx_en ^ expected_rx_en) &&
                expected_tx_en === (expected_tx_en ^ tx_en ^ expected_tx_en)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, data_ready=%b, rx_en=%b, tx_en=%b",
                         data_out, data_ready, rx_en, tx_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, data_ready=%b, rx_en=%b, tx_en=%b",
                         expected_data_out, expected_data_ready, expected_rx_en, expected_tx_en);
                $display("  Got:      data_out=%b, data_ready=%b, rx_en=%b, tx_en=%b",
                         data_out, data_ready, rx_en, tx_en);
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
        $dumpvars(0,clk, data_in, reset, data_out, data_ready, rx_en, tx_en);
    end

endmodule
