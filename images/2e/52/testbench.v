`timescale 1ns/1ps

module uart_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg rx;
    wire [7:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_receiver dut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        rx = 1;
        #(CLK_PERIOD * 2);
        rst = 0;
        #(CLK_PERIOD * 2);
    end
        endtask
    task send_byte;

        input [7:0] byte_to_send;
        integer i;
        begin

            rx = 0;
            #(BIT_TIME);


            for (i = 0; i < 8; i = i + 1) begin
                rx = byte_to_send[i];
                #(BIT_TIME);
            end


            rx = 1;
            #(BIT_TIME);
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Sending 0x55 (01010101)");
        reset_dut();
        send_byte(8'h55);
        @(posedge valid);
        #(CLK_PERIOD/2);
        #1;

        check_outputs(8'h55, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Sending 0xAA (10101010)");
        reset_dut();
        send_byte(8'hAA);
        @(posedge valid);
        #(CLK_PERIOD/2);
        #1;

        check_outputs(8'hAA, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Sending 0x00");
        reset_dut();
        send_byte(8'h00);
        @(posedge valid);
        #(CLK_PERIOD/2);
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Sending 0xFF");
        reset_dut();
        send_byte(8'hFF);
        @(posedge valid);
        #(CLK_PERIOD/2);
        #1;

        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Sending 0xA5 (10100101)");
        reset_dut();
        send_byte(8'hA5);
        @(posedge valid);
        #(CLK_PERIOD/2);
        #1;

        check_outputs(8'hA5, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_receiver Testbench");
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
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, rst, rx, data_out, valid);
    end

endmodule
