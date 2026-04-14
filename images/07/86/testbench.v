`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg rx;
    reg start_tx;
    wire [7:0] data_out;
    wire data_ready;
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
        .rx(rx),
        .start_tx(start_tx),
        .data_out(data_out),
        .data_ready(data_ready),
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
            rx = 1;
            start_tx = 0;
            data_in = 8'h00;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task receive_serial_byte;

        input [7:0] byte_to_send;
        integer i;
        begin

            rx = 0;
            #(BIT_PERIOD);

            for (i = 0; i < 8; i = i + 1) begin
                rx = byte_to_send[i];
                #(BIT_PERIOD);
            end

            rx = 1;
            #(BIT_PERIOD);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Receive 8'hAA serially", test_num);
            reset_dut();
            receive_serial_byte(8'hAA);
            #20;

            #1;


            check_outputs(8'hAA, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Receive 8'h55 serially", test_num);
            reset_dut();
            receive_serial_byte(8'h55);
            #20;
            #1;

            check_outputs(8'h55, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Transmit 8'hF0", test_num);
            reset_dut();
            data_in = 8'hF0;
            start_tx = 1;
            #10;
            start_tx = 0;

            #(BIT_PERIOD * 11);

            #1;


            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Receive 8'h00 serially", test_num);
            reset_dut();
            receive_serial_byte(8'h00);
            #20;
            #1;

            check_outputs(8'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Receive 8'hFF serially", test_num);
            reset_dut();
            receive_serial_byte(8'hFF);
            #20;
            #1;

            check_outputs(8'hFF, 1'b1, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_data_ready;
        input expected_tx;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b, tx=%b",
                         data_out, data_ready, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b, tx=%b",
                         expected_data_out, expected_data_ready, expected_tx);
                $display("  Got:      data_out=%h, data_ready=%b, tx=%b",
                         data_out, data_ready, tx);
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
        $dumpvars(0,clk, data_in, reset, rx, start_tx, data_out, data_ready, tx);
    end

endmodule
