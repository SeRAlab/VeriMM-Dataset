`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg tx_en;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .tx_en(tx_en),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            tx_en = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task run_uart_transaction;

        input [7:0] data;
        reg [9:0] captured_frame;
        reg [9:0] expected_frame;
        integer i;
        begin
            data_in = data;
            expected_frame = {1'b1, data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0], 1'b0};


            tx_en = 1;
            @(posedge clk);
            #1 tx_en = 0;


            for (i = 0; i < 10; i = i + 1) begin
                captured_frame[i] = tx;
                @(posedge clk);
                #1;
            end




            #1;





            check_outputs(captured_frame === expected_frame);
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Transmitting 0x55 (01010101)");
            reset_dut();
            run_uart_transaction(8'h55);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Transmitting 0xAA (10101010)");
            reset_dut();
            run_uart_transaction(8'hAA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Transmitting 0x00 (All Zeros)");
            reset_dut();
            run_uart_transaction(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Transmitting 0xFF (All Ones)");
            reset_dut();
            run_uart_transaction(8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Transmitting 0xC3 (11000011)");
            reset_dut();
            run_uart_transaction(8'hC3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_transmitter Testbench");
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
        input expected_tx;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: tx=%b",
                         tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b",
                         expected_tx);
                $display("  Got:      tx=%b",
                         tx);
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
        $dumpvars(0,clk, data_in, rst, tx_en, tx);
    end

endmodule
