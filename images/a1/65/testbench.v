`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] tb_rx_data;
    reg tb_rx_done;
    wire tb_tx_busy;
    wire [7:0] tb_tx_data;
    wire tb_tx_start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .tb_rx_data(tb_rx_data),
        .tb_rx_done(tb_rx_done),
        .tb_tx_busy(tb_tx_busy),
        .tb_tx_data(tb_tx_data),
        .tb_tx_start(tb_tx_start)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            tb_rx_data = 0;
            tb_rx_done = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task rx_byte;

        input [7:0] data;
        begin
            tb_rx_data = data;
            tb_rx_done = 1;
            @(posedge clk);
            #1;
            tb_rx_done = 0;
            tb_rx_data = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("\nRunning testcase001: Load 3 bytes and check start");
            reset_dut();
            rx_byte(8'hA1);
            rx_byte(8'hB2);
            rx_byte(8'hC3);


            #1;



            check_outputs(1'b1, 8'hA1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Load 2 bytes and verify idle");
            reset_dut();
            rx_byte(8'h11);
            rx_byte(8'h22);

            #1;


            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Reset mid-reception");
            reset_dut();
            rx_byte(8'hFF);
            reset_dut();
            rx_byte(8'h10);
            rx_byte(8'h20);
            rx_byte(8'h30);

            #1;


            check_outputs(1'b1, 8'h10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Post-reset idle check");
            reset_dut();
            #1;

            check_outputs(1'b0, 8'h00, 1'b0);
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
        input expected_tb_tx_busy;
        input [7:0] expected_tb_tx_data;
        input expected_tb_tx_start;
        begin
            if (expected_tb_tx_busy === (expected_tb_tx_busy ^ tb_tx_busy ^ expected_tb_tx_busy) &&
                expected_tb_tx_data === (expected_tb_tx_data ^ tb_tx_data ^ expected_tb_tx_data) &&
                expected_tb_tx_start === (expected_tb_tx_start ^ tb_tx_start ^ expected_tb_tx_start)) begin
                $display("PASS");
                $display("  Outputs: tb_tx_busy=%b, tb_tx_data=%h, tb_tx_start=%b",
                         tb_tx_busy, tb_tx_data, tb_tx_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tb_tx_busy=%b, tb_tx_data=%h, tb_tx_start=%b",
                         expected_tb_tx_busy, expected_tb_tx_data, expected_tb_tx_start);
                $display("  Got:      tb_tx_busy=%b, tb_tx_data=%h, tb_tx_start=%b",
                         tb_tx_busy, tb_tx_data, tb_tx_start);
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
        $dumpvars(0,clk, rst, tb_rx_data, tb_rx_done, tb_tx_busy, tb_tx_data, tb_tx_start);
    end

endmodule
