`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg reset;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reset(reset),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin
            reset = 1;
            serial_in = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin

            @(posedge clk);
            #1 serial_in = 0;


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1 serial_in = data[i];
            end


            @(posedge clk);
            #1 serial_in = 1;


            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: Sending 0x55 (Pattern 01010101)");
            reset_dut();
            send_byte(8'h55);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Sending 0xAA (Pattern 10101010)");
            reset_dut();
            send_byte(8'hAA);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Sending 0xFF");
            reset_dut();
            send_byte(8'hFF);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Sending 0x00");
            reset_dut();
            send_byte(8'h00);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Reset during transmission");
            reset_dut();

            @(posedge clk); #1 serial_in = 0;

            repeat(4) @(posedge clk);

            #1 reset = 1;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            serial_in = 1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Consecutive bytes (0x12 then 0x34)");
            reset_dut();
            send_byte(8'h12);

            if (parallel_out !== 8'h12) $display("  Intermediate Fail: 0x12 not received");

            send_byte(8'h34);

            #1;


            check_outputs(8'h34);
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
        input [7:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,reset, serial_in, parallel_out);
    end

endmodule
