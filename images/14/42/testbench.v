`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg send;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .send(send),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        send = 0;
        data_in = 8'h00;
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(5) @(posedge clk);
    end
        endtask
    task verify_uart_frame;

        input [7:0] expected_data;
        reg [9:0] captured_frame;
        integer bit_idx;
        begin

            wait(tx == 0);


            repeat(CPB/2) @(posedge clk);

            for (bit_idx = 0; bit_idx < 10; bit_idx = bit_idx + 1) begin
                captured_frame[bit_idx] = tx;
                repeat(CPB) @(posedge clk);
            end



            if (captured_frame === {1'b1, expected_data, 1'b0}) begin
                $display("  Frame Match: Data 0x%h received correctly.", expected_data);
                #1;

                check_outputs(tx);
            end else begin
                $display("  Frame Mismatch: Expected {1, %b, 0}, Got %b", expected_data, captured_frame);
                #1;

                check_outputs(~tx);
            end
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transmitting 0x55", test_num);
        reset_dut();
        data_in = 8'h55;
        send = 1;
        @(posedge clk);
        send = 0;
        verify_uart_frame(8'h55);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transmitting 0xAA", test_num);
        reset_dut();
        data_in = 8'hAA;
        send = 1;
        @(posedge clk);
        send = 0;
        verify_uart_frame(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transmitting 0x00", test_num);
        reset_dut();
        data_in = 8'h00;
        send = 1;
        @(posedge clk);
        send = 0;
        verify_uart_frame(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transmitting 0xFF", test_num);
        reset_dut();
        data_in = 8'hFF;
        send = 1;
        @(posedge clk);
        send = 0;
        verify_uart_frame(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transmitting 0x12", test_num);
        reset_dut();
        data_in = 8'h12;
        send = 1;
        @(posedge clk);
        send = 0;
        verify_uart_frame(8'h12);
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
        $dumpvars(0,clk, data_in, reset, send, tx);
    end

endmodule
