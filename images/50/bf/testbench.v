`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_sys;
    reg [7:0] din;
    reg rx;
    reg spi_di;
    reg tx;
    wire [7:0] dout;
    wire spi_clk;
    wire spi_do;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_sys(clk_sys),
        .din(din),
        .rx(rx),
        .spi_di(spi_di),
        .tx(tx),
        .dout(dout),
        .spi_clk(spi_clk),
        .spi_do(spi_do)
    );

    // Clock generation (10ns period)
    initial begin
        clk_sys = 0;
        forever #5 clk_sys = ~clk_sys;
    end

        task reset_dut;

        begin
            tx = 0;
            rx = 0;
            din = 0;
            spi_di = 0;
            repeat(10) @(posedge clk_sys);
        end
        endtask
    task provide_spi_input;

        input [7:0] data_to_send;
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin

                @(negedge spi_clk);
                spi_di = data_to_send[i];
            end
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Basic Transmission (0xA5)");
            test_num = 1;
            reset_dut();
            din = 8'hA5;
            @(posedge clk_sys);
            tx = 1;
            @(posedge clk_sys);
            tx = 0;


            repeat(8) @(posedge spi_clk);
            repeat(20) @(posedge clk_sys);


            #1;



            check_outputs(8'h00, 0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Reception (0x5A)");
            test_num = 2;
            reset_dut();
            @(posedge clk_sys);
            rx = 1;
            @(posedge clk_sys);
            rx = 0;


            provide_spi_input(8'h5A);

            repeat(20) @(posedge clk_sys);


            #1;



            check_outputs(8'h5A, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Full-Duplex (TX 0xFF, RX 0x3C)");
            test_num = 3;
            reset_dut();
            din = 8'hFF;
            @(posedge clk_sys);
            tx = 1;
            rx = 1;
            @(posedge clk_sys);
            tx = 0;
            rx = 0;

            provide_spi_input(8'h3C);

            repeat(20) @(posedge clk_sys);

            #1;


            check_outputs(8'h3C, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Reception of 0x00");
            test_num = 4;
            reset_dut();
            @(posedge clk_sys);
            rx = 1;
            @(posedge clk_sys);
            rx = 0;

            provide_spi_input(8'h00);

            repeat(20) @(posedge clk_sys);

            #1;


            check_outputs(8'h00, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reception of 0xFF");
            test_num = 5;
            reset_dut();
            @(posedge clk_sys);
            rx = 1;
            @(posedge clk_sys);
            rx = 0;

            provide_spi_input(8'hFF);

            repeat(20) @(posedge clk_sys);

            #1;


            check_outputs(8'hFF, 0, 0);
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
        input [7:0] expected_dout;
        input expected_spi_clk;
        input expected_spi_do;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_spi_clk === (expected_spi_clk ^ spi_clk ^ expected_spi_clk) &&
                expected_spi_do === (expected_spi_do ^ spi_do ^ expected_spi_do)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, spi_clk=%b, spi_do=%b",
                         dout, spi_clk, spi_do);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, spi_clk=%b, spi_do=%b",
                         expected_dout, expected_spi_clk, expected_spi_do);
                $display("  Got:      dout=%h, spi_clk=%b, spi_do=%b",
                         dout, spi_clk, spi_do);
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
        $dumpvars(0,clk_sys, din, rx, spi_di, tx, dout, spi_clk, spi_do);
    end

endmodule
