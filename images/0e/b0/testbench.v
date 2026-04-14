`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start_bit;
    reg stop_bit;
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
        .start_bit(start_bit),
        .stop_bit(stop_bit),
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
        data_in = 8'b0;
        start_bit = 1'b0;
        stop_bit = 1'b1;
        tx_en = 0;
        repeat(5) @(posedge clk);
    end
        endtask
    task run_uart_transaction;

        input [7:0] data;
        input s_bit;
        input p_bit;
        integer i;
        begin
            data_in = data;
            start_bit = s_bit;
            stop_bit = p_bit;
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;


            #1; #1;
 check_outputs(s_bit);
            @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                #1; #1;
 check_outputs(data[i]);
                @(posedge clk);
            end


            #1; #1;
 check_outputs(p_bit);
            @(posedge clk);
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Transmitting 0x55 (10101010)", test_num);
        reset_dut();
        run_uart_transaction(8'h55, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Transmitting 0x00", test_num);
        reset_dut();
        run_uart_transaction(8'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Transmitting 0xFF", test_num);
        reset_dut();
        run_uart_transaction(8'hFF, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Custom Frame (Start=1, Stop=0, Data=0xA5)", test_num);
        reset_dut();
        run_uart_transaction(8'hA5, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Idle State Check", test_num);
        reset_dut();

        run_uart_transaction(8'hAA, 1'b0, 1'b1);

        repeat(3) @(posedge clk);
        #1; #1;
 check_outputs(1'b1);
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
        $dumpvars(0,clk, data_in, start_bit, stop_bit, tx_en, tx);
    end

endmodule
