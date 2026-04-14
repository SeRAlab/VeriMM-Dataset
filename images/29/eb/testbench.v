`timescale 1ns/1ps

module uart_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] data;
    wire data_valid;

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
        .data_valid(data_valid)
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
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task send_uart_byte;

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
            reset_dut();
            $display("Testcase %03d: Sending 0x55", test_num);
            send_uart_byte(8'h55);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Sending 0xAA", test_num);
            send_uart_byte(8'hAA);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Sending 0x00", test_num);
            send_uart_byte(8'h00);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Sending 0xFF", test_num);
            send_uart_byte(8'hFF);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Sending 0x3C then 0xC3", test_num);
            send_uart_byte(8'h3C);

            #(BIT_PERIOD * 2);
            send_uart_byte(8'hC3);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'hC3, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: Idle line check", test_num);
            #(BIT_PERIOD * 5);
            #1;

            check_outputs(8'h00, 1'b0);
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
        input expected_data_valid;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid)) begin
                $display("PASS");
                $display("  Outputs: data=%h, data_valid=%b",
                         data, data_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, data_valid=%b",
                         expected_data, expected_data_valid);
                $display("  Got:      data=%h, data_valid=%b",
                         data, data_valid);
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
        $dumpvars(0,clk, reset, rx, data, data_valid);
    end

endmodule
