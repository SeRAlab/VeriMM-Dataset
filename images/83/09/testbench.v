`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg rxd;
    wire [7:0] data;
    wire received;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .rxd(rxd),
        .data(data),
        .received(received)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rxd = 1;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] val;
        integer i;
        begin

            rxd = 0;
            @(posedge clk);

            for (i = 0; i < 8; i = i + 1) begin
                rxd = val[i];
                @(posedge clk);
            end

            rxd = 1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Sending 0xA5...");
            reset_dut();
            send_byte(8'hA5);

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Sending 0x5A...");
            reset_dut();
            send_byte(8'h5A);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Sending 0x00...");
            reset_dut();
            send_byte(8'h00);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Sending 0xFF...");
            reset_dut();
            send_byte(8'hFF);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Sending 0xF0...");
            reset_dut();
            send_byte(8'hF0);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0, 1'b1);
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
        input expected_received;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_received === (expected_received ^ received ^ expected_received)) begin
                $display("PASS");
                $display("  Outputs: data=%h, received=%b",
                         data, received);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, received=%b",
                         expected_data, expected_received);
                $display("  Got:      data=%h, received=%b",
                         data, received);
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
        $dumpvars(0,clk, rst, rxd, data, received);
    end

endmodule
