`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BAUD_CLK;
    reg RESET_N;
    reg RX_DATA;
    reg RX_PARITY;
    reg RX_PAR_DIS;
    reg RX_WORD;
    wire FRAME;
    wire PARITY_ERR;
    wire READY;
    wire [7:0] RX_BUFFER;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BAUD_CLK(BAUD_CLK),
        .RESET_N(RESET_N),
        .RX_DATA(RX_DATA),
        .RX_PARITY(RX_PARITY),
        .RX_PAR_DIS(RX_PAR_DIS),
        .RX_WORD(RX_WORD),
        .FRAME(FRAME),
        .PARITY_ERR(PARITY_ERR),
        .READY(READY),
        .RX_BUFFER(RX_BUFFER)
    );

    // Clock generation (10ns period)
    initial begin
        BAUD_CLK = 0;
        forever #5 BAUD_CLK = ~BAUD_CLK;
    end

        task reset_dut;

        begin
            RESET_N = 0;
            RX_DATA = 1;
            RX_PARITY = 0;
            RX_PAR_DIS = 1;
            RX_WORD = 1;
            repeat (2) @(posedge BAUD_CLK);
            RESET_N = 1;
            repeat (1) @(posedge BAUD_CLK);
        end
        endtask
    task send_uart_byte;

        input [7:0] data;
        input parity_bit;
        input use_parity;
        integer i;
        begin

            RX_DATA = 0;
            @(posedge BAUD_CLK);


            for (i = 0; i < 8; i = i + 1) begin
                RX_DATA = data[i];
                @(posedge BAUD_CLK);
            end


            if (use_parity) begin
                RX_DATA = parity_bit;
                @(posedge BAUD_CLK);
            end


            RX_DATA = 1;
            @(posedge BAUD_CLK);


            wait(READY == 1);
            @(posedge BAUD_CLK);
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: 8-bit Data, No Parity (Data: 8'hA5)");
            reset_dut();
            RX_PAR_DIS = 1;
            RX_WORD = 1;

            send_uart_byte(8'hA5, 0, 0);

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: 8-bit Data, Even Parity Correct (Data: 8'h33)");
            reset_dut();
            RX_PAR_DIS = 0;
            RX_PARITY = 0;
            RX_WORD = 1;

            send_uart_byte(8'h33, 1'b0, 1);

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 8'h33);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: 8-bit Data, Odd Parity Correct (Data: 8'h33)");
            reset_dut();
            RX_PAR_DIS = 0;
            RX_PARITY = 1;
            RX_WORD = 1;

            send_uart_byte(8'h33, 1'b1, 1);

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 8'h33);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: 8-bit Data, Even Parity Error (Data: 8'hF0)");
            reset_dut();
            RX_PAR_DIS = 0;
            RX_PARITY = 0;
            RX_WORD = 1;


            send_uart_byte(8'hF0, 1'b1, 1);

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 8'hF0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: 8-bit Data, Odd Parity Error (Data: 8'hAA)");
            reset_dut();
            RX_PAR_DIS = 0;
            RX_PARITY = 1;
            RX_WORD = 1;


            send_uart_byte(8'hAA, 1'b0, 1);

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 8'hAA);
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
        input expected_FRAME;
        input expected_PARITY_ERR;
        input expected_READY;
        input [7:0] expected_RX_BUFFER;
        begin
            if (expected_FRAME === (expected_FRAME ^ FRAME ^ expected_FRAME) &&
                expected_PARITY_ERR === (expected_PARITY_ERR ^ PARITY_ERR ^ expected_PARITY_ERR) &&
                expected_READY === (expected_READY ^ READY ^ expected_READY) &&
                expected_RX_BUFFER === (expected_RX_BUFFER ^ RX_BUFFER ^ expected_RX_BUFFER)) begin
                $display("PASS");
                $display("  Outputs: FRAME=%b, PARITY_ERR=%b, READY=%b, RX_BUFFER=%h",
                         FRAME, PARITY_ERR, READY, RX_BUFFER);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FRAME=%b, PARITY_ERR=%b, READY=%b, RX_BUFFER=%h",
                         expected_FRAME, expected_PARITY_ERR, expected_READY, expected_RX_BUFFER);
                $display("  Got:      FRAME=%b, PARITY_ERR=%b, READY=%b, RX_BUFFER=%h",
                         FRAME, PARITY_ERR, READY, RX_BUFFER);
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
        $dumpvars(0,BAUD_CLK, RESET_N, RX_DATA, RX_PARITY, RX_PAR_DIS, RX_WORD, FRAME, PARITY_ERR, READY, RX_BUFFER);
    end

endmodule
