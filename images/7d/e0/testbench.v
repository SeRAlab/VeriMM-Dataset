`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg rx_ready;
    reg [7:0] tx_data;
    reg tx_valid;
    wire [7:0] rx_data;
    wire rx_valid;
    wire tx_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .rx_ready(rx_ready),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .tx_ready(tx_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rx_ready = 0;
            tx_data = 8'h0;
            tx_valid = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;


            #1;



            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            rx_ready = 1'b1;
            tx_data = 8'hA5;
            tx_valid = 1'b1;

            @(posedge clk);
            tx_valid = 1'b0;




            repeat(50) @(posedge clk);


            #1;



            check_outputs(8'hA5, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            rx_ready = 1'b1;
            tx_data = 8'h5A;
            tx_valid = 1'b1;

            @(posedge clk);
            tx_valid = 1'b0;

            repeat(50) @(posedge clk);

            #1;


            check_outputs(8'h5A, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            rx_ready = 1'b1;
            tx_data = 8'hFF;
            tx_valid = 1'b1;

            @(posedge clk);
            tx_valid = 1'b0;

            repeat(50) @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            rx_ready = 1'b1;
            tx_data = 8'h00;
            tx_valid = 1'b1;

            @(posedge clk);
            tx_valid = 1'b0;

            repeat(50) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            rx_ready = 1'b0;
            tx_data = 8'h33;
            tx_valid = 1'b1;

            @(posedge clk);
            tx_valid = 1'b0;


            repeat(40) @(posedge clk);


            rx_ready = 1'b1;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(8'h33, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_rx_data;
        input expected_rx_valid;
        input expected_tx_ready;
        begin
            if (expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data) &&
                expected_rx_valid === (expected_rx_valid ^ rx_valid ^ expected_rx_valid) &&
                expected_tx_ready === (expected_tx_ready ^ tx_ready ^ expected_tx_ready)) begin
                $display("PASS");
                $display("  Outputs: rx_data=%h, rx_valid=%b, tx_ready=%b",
                         rx_data, rx_valid, tx_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data=%h, rx_valid=%b, tx_ready=%b",
                         expected_rx_data, expected_rx_valid, expected_tx_ready);
                $display("  Got:      rx_data=%h, rx_valid=%b, tx_ready=%b",
                         rx_data, rx_valid, tx_ready);
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
        $dumpvars(0,clk, rst, rx_ready, tx_data, tx_valid, rx_data, rx_valid, tx_ready);
    end

endmodule
