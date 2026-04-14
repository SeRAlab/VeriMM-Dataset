`timescale 1ns/1ps

module uart_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] data_out;
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
        .data_out(data_out),
        .data_ready(data_ready)
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
            #20;
            reset = 0;
            #20;
        end
        endtask
    task send_byte;

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
            test_num = test_num + 1;
            $display("Test Case %0d: Receive 0x55 (Alternating 01010101)", test_num);
            reset_dut();
            send_byte(8'h55);

            wait(data_ready == 1);
            #(1);
            #1;

            check_outputs(8'h55, 1);
            #(BIT_PERIOD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Receive 0xAA (Alternating 10101010)", test_num);
            reset_dut();
            send_byte(8'hAA);
            wait(data_ready == 1);
            #(1);
            #1;

            check_outputs(8'hAA, 1);
            #(BIT_PERIOD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Receive 0xFF (All ones)", test_num);
            reset_dut();
            send_byte(8'hFF);
            wait(data_ready == 1);
            #(1);
            #1;

            check_outputs(8'hFF, 1);
            #(BIT_PERIOD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Receive 0x00 (All zeros)", test_num);
            reset_dut();
            send_byte(8'h00);
            wait(data_ready == 1);
            #(1);
            #1;

            check_outputs(8'h00, 1);
            #(BIT_PERIOD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Receive 0xA5 (Mixed pattern)", test_num);
            reset_dut();
            send_byte(8'hA5);
            wait(data_ready == 1);
            #(1);
            #1;

            check_outputs(8'hA5, 1);
            #(BIT_PERIOD);
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
        input expected_data_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b",
                         data_out, data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b",
                         expected_data_out, expected_data_ready);
                $display("  Got:      data_out=%h, data_ready=%b",
                         data_out, data_ready);
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
        $dumpvars(0,clk, reset, rx, data_out, data_ready);
    end

endmodule
