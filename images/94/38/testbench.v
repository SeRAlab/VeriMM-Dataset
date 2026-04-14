`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg baud_t_enable;
    reg clk;
    reg [7:0] data;
    reg data_t_enable;
    reg rst;
    wire tbr;
    wire txd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .baud_t_enable(baud_t_enable),
        .clk(clk),
        .data(data),
        .data_t_enable(data_t_enable),
        .rst(rst),
        .tbr(tbr),
        .txd(txd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            baud_t_enable = 0;
            data_t_enable = 0;
            data = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task pulse_baud_enable;

        begin
            @(posedge clk);
            #1 baud_t_enable = 1;
            @(posedge clk);
            #1 baud_t_enable = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset and Idle State Check");
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase 002: Transmit Data 0x55");
            reset_dut();


            data = 8'h55;
            data_t_enable = 1;
            @(posedge clk);
            #1 data_t_enable = 0;


            for (i = 0; i < 10; i = i + 1) begin
                pulse_baud_enable();
            end


            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase 003: Transmit Data 0x00");
            reset_dut();

            data = 8'h00;
            data_t_enable = 1;
            @(posedge clk);
            #1 data_t_enable = 0;

            for (i = 0; i < 10; i = i + 1) begin
                pulse_baud_enable();
            end

            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Check TBR during transmission");
            reset_dut();

            data = 8'hFF;
            data_t_enable = 1;
            @(posedge clk);
            #1 data_t_enable = 0;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase 005: Consecutive Transmissions 0xAA then 0x33");
            reset_dut();


            data = 8'hAA;
            data_t_enable = 1;
            @(posedge clk);
            #1 data_t_enable = 0;
            for (i = 0; i < 10; i = i + 1) pulse_baud_enable();


            @(posedge clk);
            data = 8'h33;
            data_t_enable = 1;
            @(posedge clk);
            #1 data_t_enable = 0;
            for (i = 0; i < 10; i = i + 1) pulse_baud_enable();

            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_tbr;
        input expected_txd;
        begin
            if (expected_tbr === (expected_tbr ^ tbr ^ expected_tbr) &&
                expected_txd === (expected_txd ^ txd ^ expected_txd)) begin
                $display("PASS");
                $display("  Outputs: tbr=%b, txd=%b",
                         tbr, txd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tbr=%b, txd=%b",
                         expected_tbr, expected_txd);
                $display("  Got:      tbr=%b, txd=%b",
                         tbr, txd);
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
        $dumpvars(0,baud_t_enable, clk, data, data_t_enable, rst, tbr, txd);
    end

endmodule
