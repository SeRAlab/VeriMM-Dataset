`timescale 1ns/1ps

module uart_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg baud_tick;
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg start;
    reg stop;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_transmitter dut (
        .baud_tick(baud_tick),
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .start(start),
        .stop(stop),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1'b0;
            baud_tick = 1'b0;
            start = 1'b0;
            data_in = 8'h00;
            stop = 1'b1;
            repeat(5) @(posedge clk);
            rst_n = 1'b1;
            repeat(5) @(posedge clk);
        end
        endtask
    task run_uart_transaction;

        input [7:0] send_data;
        input send_stop;
        reg [9:0] captured_frame;
        reg [9:0] expected_frame;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\n--- Test Case %0d: Sending Data 0x%h ---", test_num, send_data);


            data_in = send_data;
            stop = send_stop;


            @(posedge clk);
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;



            for (i = 0; i < 10; i = i + 1) begin
                #1;
                captured_frame[i] = tx;


                baud_tick = 1'b1;
                @(posedge clk);
                baud_tick = 1'b0;


                repeat(4) @(posedge clk);
            end



            expected_frame[0] = 1'b0;
            expected_frame[8:1] = send_data;
            expected_frame[9] = send_stop;


            if (captured_frame === expected_frame) begin
                $display("  Success: Frame %b matches expected.", captured_frame);
                #1;

                check_outputs(tx);
            end else begin
                $display("  Error: Frame %b != Expected %b", captured_frame, expected_frame);
                #1;

                check_outputs(~tx);
            end
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_uart_transaction(8'h55, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_uart_transaction(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_uart_transaction(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_uart_transaction(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_uart_transaction(8'hA5, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            run_uart_transaction(8'h3C, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            run_uart_transaction(8'h81, 1'b1);
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
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,baud_tick, clk, data_in, rst_n, start, stop, tx);
    end

endmodule
