`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg tx_start;
    wire tx_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .tx_start(tx_start),
        .tx_out(tx_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            tx_start = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task run_uart_transaction;

        input [7:0] byte_to_send;
        reg [9:0] frame;
        integer i;
        begin
            data_in = byte_to_send;
            frame = {1'b1, byte_to_send, 1'b0};

            @(posedge clk);
            tx_start = 1;
            @(posedge clk);
            tx_start = 0;


            for (i = 0; i < 10; i = i + 1) begin
                #1;
                #1;

                check_outputs(frame[i]);
                @(posedge clk);
            end


            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0x55 (Alternating bits)", test_num);
            reset_dut();
            run_uart_transaction(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0xAA (Alternating bits inverted)", test_num);
            reset_dut();
            run_uart_transaction(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0x00 (All data bits low)", test_num);
            reset_dut();
            run_uart_transaction(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0xFF (All data bits high)", test_num);
            reset_dut();
            run_uart_transaction(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transmitting 0xC3 (Mixed bit pattern)", test_num);
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
        input expected_tx_out;
        begin
            if (expected_tx_out === (expected_tx_out ^ tx_out ^ expected_tx_out)) begin
                $display("PASS");
                $display("  Outputs: tx_out=%b",
                         tx_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_out=%b",
                         expected_tx_out);
                $display("  Got:      tx_out=%b",
                         tx_out);
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
        $dumpvars(0,clk, data_in, rst, tx_start, tx_out);
    end

endmodule
