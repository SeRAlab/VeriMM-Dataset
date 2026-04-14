`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg send;
    wire [7:0] data_out;
    wire received;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .send(send),
        .data_out(data_out),
        .received(received),
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
            rx = 1;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task drive_rx;

        input [7:0] data;
        integer i;
        begin

            rx = 0;
            #(BIT_PERIOD);

            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BIT_PERIOD);
            end

            rx = 1;
            #(BIT_PERIOD);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Receiving Serial Byte 0xA5", test_num);
            reset_dut();
            drive_rx(8'hA5);
            #(BIT_PERIOD);

            #1;


            check_outputs(8'hA5, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Receiving Serial Byte 0x3C", test_num);
            reset_dut();
            drive_rx(8'h3C);
            #(BIT_PERIOD);
            #1;

            check_outputs(8'h3C, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transmitting Byte 0x5A", test_num);
            reset_dut();
            data_in = 8'h5A;
            send = 1;
            #10;
            send = 0;

            #(BIT_PERIOD * 11);


            #1;



            check_outputs(8'h00, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Transmitting Byte 0xFF", test_num);
            reset_dut();
            data_in = 8'hFF;
            send = 1;
            #10;
            send = 0;
            #(BIT_PERIOD * 11);
            #1;

            check_outputs(8'h00, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_received;
        input expected_tx;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_received === (expected_received ^ received ^ expected_received) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, received=%b, tx=%b",
                         data_out, received, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, received=%b, tx=%b",
                         expected_data_out, expected_received, expected_tx);
                $display("  Got:      data_out=%h, received=%b, tx=%b",
                         data_out, received, tx);
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
        $dumpvars(0,clk, data_in, reset, send, data_out, received, tx);
    end

endmodule
