`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    reg rx;
    reg s_tick;
    wire [7:0] d_out;
    wire rx_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .rx(rx),
        .s_tick(s_tick),
        .d_out(d_out),
        .rx_done(rx_done)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            rx = 1;
            s_tick = 0;
            repeat(10) @(posedge clock);
            reset = 0;
            repeat(10) @(posedge clock);
        end
        endtask
    task tick;

        begin
            @(posedge clock);
            s_tick = 1;
            @(posedge clock);
            s_tick = 0;
            repeat(4) @(posedge clock);
        end
        endtask

    task send_byte;

        input [7:0] data;
        integer i, k;
        reg found_done;
        begin
            found_done = 0;

            rx = 0;
            repeat(16) tick();


            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                repeat(16) tick();
            end


            rx = 1;

            for (k = 0; k < 16; k = k + 1) begin
                if (!found_done) begin
                    tick();
                    if (rx_done) found_done = 1;
                end
            end

            repeat(2) @(posedge clock);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running Testcase001: Data 0x55");
            send_byte(8'h55);
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running Testcase002: Data 0xAA");
            send_byte(8'hAA);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running Testcase003: Data 0x00");
            send_byte(8'h00);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running Testcase004: Data 0xFF");
            send_byte(8'hFF);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Running Testcase005: Data 0xA5");
            send_byte(8'hA5);
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Running Testcase006: Data 0x3C");
            send_byte(8'h3C);
            #1;

            check_outputs(8'h3C, 1'b1);
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
        input [7:0] expected_d_out;
        input expected_rx_done;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out) &&
                expected_rx_done === (expected_rx_done ^ rx_done ^ expected_rx_done)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h, rx_done=%b",
                         d_out, rx_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h, rx_done=%b",
                         expected_d_out, expected_rx_done);
                $display("  Got:      d_out=%h, rx_done=%b",
                         d_out, rx_done);
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
        $dumpvars(0,clock, reset, rx, s_tick, d_out, rx_done);
    end

endmodule
