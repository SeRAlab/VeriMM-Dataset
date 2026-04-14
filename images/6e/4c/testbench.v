`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RD;
    reg RST;
    reg RX;
    wire [7:0] D;
    wire RXNE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RD(RD),
        .RST(RST),
        .RX(RX),
        .D(D),
        .RXNE(RXNE)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            RD = 0;
            RX = 1;
            repeat(5) @(posedge CLK);
            RST = 0;
            repeat(5) @(posedge CLK);
        end
        endtask
    task send_uart_byte;

        input [7:0] data;
        integer i;
        begin

            RX = 0;
            repeat(BIT_TIME) @(posedge CLK);

            for (i = 0; i < 8; i = i + 1) begin
                RX = data[i];
                repeat(BIT_TIME) @(posedge CLK);
            end

            RX = 1;
            repeat(BIT_TIME) @(posedge CLK);

            repeat(2) @(posedge CLK);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            send_uart_byte(8'h55);
            $display("Testcase %0d: Receiving 0x55", test_num);
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            send_uart_byte(8'hAA);
            $display("Testcase %0d: Receiving 0xAA", test_num);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            send_uart_byte(8'h3C);

            @(posedge CLK);
            RD = 1;
            @(posedge CLK);
            RD = 0;
            @(posedge CLK);
            $display("Testcase %0d: Reading data (RD pulse)", test_num);
            #1;

            check_outputs(8'h3C, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Check state after Reset", test_num);
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            send_uart_byte(8'hFF);
            $display("Testcase %0d: Receiving 0xFF", test_num);
            #1;

            check_outputs(8'hFF, 1'b1);
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
        input [7:0] expected_D;
        input expected_RXNE;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_RXNE === (expected_RXNE ^ RXNE ^ expected_RXNE)) begin
                $display("PASS");
                $display("  Outputs: D=%h, RXNE=%b",
                         D, RXNE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, RXNE=%b",
                         expected_D, expected_RXNE);
                $display("  Got:      D=%h, RXNE=%b",
                         D, RXNE);
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
        $dumpvars(0,CLK, RD, RST, RX, D, RXNE);
    end

endmodule
