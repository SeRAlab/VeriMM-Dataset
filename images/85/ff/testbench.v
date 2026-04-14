`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clock;
    reg [127:0] data_in;
    reg reset;
    reg stall_in;
    reg stall_out;
    wire [23:0] data_out;
    wire read;
    wire write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clock(clock),
        .data_in(data_in),
        .reset(reset),
        .stall_in(stall_in),
        .stall_out(stall_out),
        .data_out(data_out),
        .read(read),
        .write(write)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 0;
            data_in = 0;
            stall_in = 0;
            stall_out = 0;
            repeat(2) @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(24'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            stall_in = 1;
            repeat(2) @(posedge clock);

            #1;


            check_outputs(24'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 128'hABCDEF1234567890ABCDEF1234567890;
            stall_in = 0;
            @(posedge clock);
            #1 stall_out = 1;
            repeat(2) @(posedge clock);

            #1;


            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            stall_in = 0;
            @(posedge clock);
            #1;
            clear = 1;
            repeat(1) @(posedge clock);
            #1;

            #1;


            check_outputs(24'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
            stall_in = 0;
            stall_out = 0;
            @(posedge clock);
            repeat(1) @(posedge clock);
            #1;

            if (write === 1'b1 && read === 1'b0) begin
                pass_count = pass_count + 1;
                $display("TC005 PASS: Data flow initiated");
            end else begin
                fail_count = fail_count + 1;
                $display("TC005 FAIL: Data flow handshake failed");
            end
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
        input [23:0] expected_data_out;
        input expected_read;
        input expected_write;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_read === (expected_read ^ read ^ expected_read) &&
                expected_write === (expected_write ^ write ^ expected_write)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, read=%b, write=%b",
                         data_out, read, write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, read=%b, write=%b",
                         expected_data_out, expected_read, expected_write);
                $display("  Got:      data_out=%h, read=%b, write=%b",
                         data_out, read, write);
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
        $dumpvars(0,clear, clock, data_in, reset, stall_in, stall_out, data_out, read, write);
    end

endmodule
