`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg rx_start;
    reg [7:0] tx_data;
    reg tx_start;
    wire [7:0] rx_data;
    wire rx_done;
    wire tx_done;
    wire [7:0] tx_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_controller dut (
        .clk(clk),
        .reset(reset),
        .rx_start(rx_start),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .tx_done(tx_done),
        .tx_out(tx_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        tx_start = 0;
        rx_start = 0;
        tx_data = 8'h00;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Transmit Data 0x55", test_num);
        reset_dut();

        tx_data = 8'h55;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;


        fork : wait_tx
            begin
                wait(tx_done == 1);
            end
            begin
                repeat(100) @(posedge clk);
            end
        join_any
        disable wait_tx;



        #1;




        check_outputs(8'h00, 1'b0, 1'b1, 8'h55);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Transmit Data 0xAA", test_num);
        reset_dut();

        tx_data = 8'hAA;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        fork : wait_tx
            begin
                wait(tx_done == 1);
            end
            begin
                repeat(100) @(posedge clk);
            end
        join_any
        disable wait_tx;

        #1;


        check_outputs(8'h00, 1'b0, 1'b1, 8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Trigger Reception", test_num);
        reset_dut();

        rx_start = 1;
        @(posedge clk);
        rx_start = 0;

        fork : wait_rx
            begin
                wait(rx_done == 1);
            end
            begin
                repeat(100) @(posedge clk);
            end
        join_any
        disable wait_rx;



        if (rx_done === 1'b1)
            #1;

            check_outputs(rx_data, 1'b1, 1'b0, 8'h00);
        else
            #1;

            check_outputs(8'h00, 1'b1, 1'b0, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Transmit Data 0xFF", test_num);
        reset_dut();

        tx_data = 8'hFF;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        fork : wait_tx
            begin
                wait(tx_done == 1);
            end
            begin
                repeat(100) @(posedge clk);
            end
        join_any
        disable wait_tx;

        #1;


        check_outputs(8'h00, 1'b0, 1'b1, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Transmit Data 0x00", test_num);
        reset_dut();

        tx_data = 8'h00;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        fork : wait_tx
            begin
                wait(tx_done == 1);
            end
            begin
                repeat(100) @(posedge clk);
            end
        join_any
        disable wait_tx;

        #1;


        check_outputs(8'h00, 1'b0, 1'b1, 8'h00);
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
        input [7:0] expected_rx_data;
        input expected_rx_done;
        input expected_tx_done;
        input [7:0] expected_tx_out;
        begin
            if (expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data) &&
                expected_rx_done === (expected_rx_done ^ rx_done ^ expected_rx_done) &&
                expected_tx_done === (expected_tx_done ^ tx_done ^ expected_tx_done) &&
                expected_tx_out === (expected_tx_out ^ tx_out ^ expected_tx_out)) begin
                $display("PASS");
                $display("  Outputs: rx_data=%h, rx_done=%b, tx_done=%b, tx_out=%h",
                         rx_data, rx_done, tx_done, tx_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data=%h, rx_done=%b, tx_done=%b, tx_out=%h",
                         expected_rx_data, expected_rx_done, expected_tx_done, expected_tx_out);
                $display("  Got:      rx_data=%h, rx_done=%b, tx_done=%b, tx_out=%h",
                         rx_data, rx_done, tx_done, tx_out);
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
        $dumpvars(0,clk, reset, rx_start, tx_data, tx_start, rx_data, rx_done, tx_done, tx_out);
    end

endmodule
