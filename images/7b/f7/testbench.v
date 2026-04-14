`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg rxd;
    wire ack;
    wire [7:0] rx_data;
    wire rx_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .rxd(rxd),
        .ack(ack),
        .rx_data(rx_data),
        .rx_full(rx_full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rxd = 1;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin

            @(posedge clk);
            #1 rxd = 0;

            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1 rxd = data[i];
            end

            @(posedge clk);
            #1 rxd = 1;

            @(posedge clk);
            #2;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running Test Case %0d: Receive 8'hA5", test_num);
            reset_dut();
            send_byte(8'hA5);
            #1;

            check_outputs(1'b1, 8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Test Case %0d: Receive 8'h5A", test_num);
            reset_dut();
            send_byte(8'h5A);
            #1;

            check_outputs(1'b1, 8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Test Case %0d: Receive 8'h00", test_num);
            reset_dut();
            send_byte(8'h00);
            #1;

            check_outputs(1'b1, 8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Test Case %0d: Receive 8'hFF", test_num);
            reset_dut();
            send_byte(8'hFF);
            #1;

            check_outputs(1'b1, 8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Test Case %0d: Receive 8'hC3", test_num);
            reset_dut();
            send_byte(8'hC3);
            #1;

            check_outputs(1'b1, 8'hC3, 1'b1);
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
        input expected_ack;
        input [7:0] expected_rx_data;
        input expected_rx_full;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data) &&
                expected_rx_full === (expected_rx_full ^ rx_full ^ expected_rx_full)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, rx_data=%h, rx_full=%b",
                         ack, rx_data, rx_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, rx_data=%h, rx_full=%b",
                         expected_ack, expected_rx_data, expected_rx_full);
                $display("  Got:      ack=%b, rx_data=%h, rx_full=%b",
                         ack, rx_data, rx_full);
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
        $dumpvars(0,clk, reset, rxd, ack, rx_data, rx_full);
    end

endmodule
