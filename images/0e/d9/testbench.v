`timescale 1ns/1ps

module uart_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg send;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_tx dut (
        .clk(clk),
        .data(data),
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
            send = 0;
            data = 8'h00;
            repeat (10) @(posedge clk);
            $display("DUT Initialized/Reset.");
        end
        endtask
    task verify_uart_frame;

        input [7:0] expected_data;
        integer i;
        begin

            wait(tx == 0);
            #(BAUD_PERIOD / 2);
            #1;

            check_outputs(1'b0);


            for (i = 0; i < 8; i = i + 1) begin
                #(BAUD_PERIOD);
                #1;

                check_outputs(expected_data[i]);
            end


            #(BAUD_PERIOD);
            #1;

            check_outputs(1'b1);


            #(BAUD_PERIOD);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0x55 (LSB: 10101010...)", test_num);
            reset_dut();
            data = 8'h55;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            verify_uart_frame(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0xAA (LSB: 01010101...)", test_num);
            reset_dut();
            data = 8'hAA;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            verify_uart_frame(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0x00", test_num);
            reset_dut();
            data = 8'h00;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            verify_uart_frame(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0xFF", test_num);
            reset_dut();
            data = 8'hFF;
            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            verify_uart_frame(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_tx Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        $dumpvars(0,clk, data, send, tx);
    end

endmodule
