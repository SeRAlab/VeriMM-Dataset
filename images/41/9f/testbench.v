`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_100MHz;
    reg Rx;
    reg reset;
    wire [7:0] LED;
    wire Tx;
    wire [7:0] recv_error;
    wire transmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_100MHz(CLK_100MHz),
        .Rx(Rx),
        .reset(reset),
        .LED(LED),
        .Tx(Tx),
        .recv_error(recv_error),
        .transmit(transmit)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_100MHz = 0;
        forever #5 CLK_100MHz = ~CLK_100MHz;
    end

        task reset_dut;

    begin
        reset = 1;
        Rx = 1;
        repeat(10) @(posedge CLK_100MHz);
        reset = 0;
        repeat(10) @(posedge CLK_100MHz);
    end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin

            Rx = 0;
            repeat(BIT_PERIOD) @(posedge CLK_100MHz);

            for (i = 0; i < 8; i = i + 1) begin
                Rx = data[i];
                repeat(BIT_PERIOD) @(posedge CLK_100MHz);
            end

            Rx = 1;
            repeat(BIT_PERIOD) @(posedge CLK_100MHz);
        end
        endtask

    task send_byte_with_error;

        input [7:0] data;
        integer i;
        begin

            Rx = 0;
            repeat(BIT_PERIOD) @(posedge CLK_100MHz);

            for (i = 0; i < 8; i = i + 1) begin
                Rx = data[i];
                repeat(BIT_PERIOD) @(posedge CLK_100MHz);
            end

            Rx = 0;
            repeat(BIT_PERIOD) @(posedge CLK_100MHz);
            Rx = 1;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Receiving 0x55", test_num);
        reset_dut();
        send_byte(8'h55);

        repeat(20) @(posedge CLK_100MHz);

        #1;


        check_outputs(8'h55, 1'b1, 8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Receiving 0xAA", test_num);
        reset_dut();
        send_byte(8'hAA);
        repeat(20) @(posedge CLK_100MHz);
        #1;

        check_outputs(8'hAA, 1'b1, 8'h00, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Framing Error Test", test_num);
        reset_dut();
        send_byte_with_error(8'hFF);
        repeat(20) @(posedge CLK_100MHz);



        if (recv_error != 8'h00) begin
             $display("PASS: Error detected as expected.");
             pass_count = pass_count + 1;
        end else begin
             $display("FAIL: No error detected on framing failure.");
             fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Successive valid bytes 0x12 then 0x34", test_num);
        reset_dut();
        send_byte(8'h12);
        repeat(50) @(posedge CLK_100MHz);
        send_byte(8'h34);
        repeat(20) @(posedge CLK_100MHz);
        #1;

        check_outputs(8'h34, 1'b1, 8'h00, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Reset during reception", test_num);
        reset_dut();

        Rx = 0;
        repeat(BIT_PERIOD) @(posedge CLK_100MHz);
        Rx = 1;
        repeat(BIT_PERIOD) @(posedge CLK_100MHz);


        reset = 1;
        repeat(10) @(posedge CLK_100MHz);
        reset = 0;
        Rx = 1;

        repeat(100) @(posedge CLK_100MHz);

        #1;


        check_outputs(8'h00, 1'b1, 8'h00, 1'b0);
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
        input [7:0] expected_LED;
        input expected_Tx;
        input [7:0] expected_recv_error;
        input expected_transmit;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED) &&
                expected_Tx === (expected_Tx ^ Tx ^ expected_Tx) &&
                expected_recv_error === (expected_recv_error ^ recv_error ^ expected_recv_error) &&
                expected_transmit === (expected_transmit ^ transmit ^ expected_transmit)) begin
                $display("PASS");
                $display("  Outputs: LED=%h, Tx=%b, recv_error=%h, transmit=%b",
                         LED, Tx, recv_error, transmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h, Tx=%b, recv_error=%h, transmit=%b",
                         expected_LED, expected_Tx, expected_recv_error, expected_transmit);
                $display("  Got:      LED=%h, Tx=%b, recv_error=%h, transmit=%b",
                         LED, Tx, recv_error, transmit);
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
        $dumpvars(0,CLK_100MHz, Rx, reset, LED, Tx, recv_error, transmit);
    end

endmodule
