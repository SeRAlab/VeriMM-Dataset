`timescale 1ns/1ps

module uart_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
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
        .rst(rst),
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
            rst = 1;
            rx = 1;
            #20;
            rst = 0;
            #100;
        end
        endtask
    task send_uart_byte;

        input [7:0] byte_to_send;
        integer i;
        begin

            rx = 0;
            #BIT_PERIOD;

            for (i = 0; i < 8; i = i + 1) begin
                rx = byte_to_send[i];
                #BIT_PERIOD;
            end

            rx = 1;
            #BIT_PERIOD;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Sending 0xA5 (10100101)", test_num);
            reset_dut();
            send_uart_byte(8'hA5);

            wait(data_ready == 1);
            #10;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Sending 0x5A (01011010)", test_num);
            reset_dut();
            send_uart_byte(8'h5A);
            wait(data_ready == 1);
            #10;
            #1;

            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Sending 0x00", test_num);
            reset_dut();
            send_uart_byte(8'h00);
            wait(data_ready == 1);
            #10;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Sending 0xFF", test_num);
            reset_dut();
            send_uart_byte(8'hFF);
            wait(data_ready == 1);
            #10;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Sending 0xC3", test_num);
            reset_dut();
            send_uart_byte(8'hC3);
            wait(data_ready == 1);
            #10;
            #1;

            check_outputs(8'hC3, 1'b1);
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
        $dumpvars(0,clk, rst, rx, data, data_ready);
    end

endmodule
