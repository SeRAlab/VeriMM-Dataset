`timescale 1ns/1ps

module uart_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] data;
    wire data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_receiver dut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data(data),
        .data_ready(data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            reset = 1;
            rx = 1;
            #(BIT_PERIOD * 2);
            reset = 0;
            #(BIT_PERIOD);
        end
        endtask
    task send_byte;

        input [7:0] byte_to_send;
        integer i;
        begin
            $display("--- Sending Byte: %h ---", byte_to_send);

            rx = 0;
            #(BIT_PERIOD);


            for (i = 0; i < 8; i = i + 1) begin
                rx = byte_to_send[i];
                #(BIT_PERIOD);
            end


            rx = 1;
            #(BIT_PERIOD);


            #(BIT_PERIOD/2);
        end
        endtask

    task testcase001;

        begin
            $display("\nTest Case 001: Standard Byte 0xA5");
            reset_dut();
            send_byte(8'hA5);
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Alternating Bits 0x55");
            reset_dut();
            send_byte(8'h55);
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: All Zeros");
            reset_dut();
            send_byte(8'h00);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: All Ones");
            reset_dut();
            send_byte(8'hFF);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Reset recovery");
            reset_dut();

            rx = 0;
            #(BIT_PERIOD * 3);
            rx = 1;
            reset_dut();


            send_byte(8'h3C);
            #1;

            check_outputs(8'h3C, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: Nibble test 0xF0");
            reset_dut();
            send_byte(8'hF0);
            #1;

            check_outputs(8'hF0, 1'b1);
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
        testcase006();
        
        
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
        input [7:0] expected_data;
        input expected_data_ready;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready)) begin
                $display("PASS");
                $display("  Outputs: data=%h, data_ready=%b",
                         data, data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, data_ready=%b",
                         expected_data, expected_data_ready);
                $display("  Got:      data=%h, data_ready=%b",
                         data, data_ready);
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
        $dumpvars(0,clk, reset, rx, data, data_ready);
    end

endmodule
