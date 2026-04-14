`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg FRAME_VALID;
    reg LINE_VALID;
    reg [9:0] PIXEL_DATA;
    reg clk;
    reg ready;
    reg reset;
    wire [9:0] data;
    wire endofpacket;
    wire startofpacket;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FRAME_VALID(FRAME_VALID),
        .LINE_VALID(LINE_VALID),
        .PIXEL_DATA(PIXEL_DATA),
        .clk(clk),
        .ready(ready),
        .reset(reset),
        .data(data),
        .endofpacket(endofpacket),
        .startofpacket(startofpacket),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            FRAME_VALID = 0;
            LINE_VALID = 0;
            PIXEL_DATA = 0;
            ready = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state after reset");
            reset_dut();

            #1;


            check_outputs(10'h000, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Frame Start (SOP) detection");
            reset_dut();
            @(negedge clk);
            FRAME_VALID = 1;
            LINE_VALID = 1;
            PIXEL_DATA = 10'h1A1;
            ready = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h1A1, 0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Mid-frame pixel transmission");
            reset_dut();
            @(negedge clk);
            FRAME_VALID = 1;
            LINE_VALID = 1;
            PIXEL_DATA = 10'h1A1;
            @(posedge clk);
            @(negedge clk);
            PIXEL_DATA = 10'h2B2;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h2B2, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: End of Packet (EOP) logic");
            reset_dut();
            @(negedge clk);
            FRAME_VALID = 1;
            LINE_VALID = 1;
            PIXEL_DATA = 10'h111;
            @(posedge clk);
            @(negedge clk);
            PIXEL_DATA = 10'h222;
            LINE_VALID = 0;
            FRAME_VALID = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(10'h222, 1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Handshake logic (ready signal)");
            reset_dut();
            @(negedge clk);
            FRAME_VALID = 1;
            LINE_VALID = 1;
            PIXEL_DATA = 10'h3FF;
            ready = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h3FF, 0, 1, 0);
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
        input [9:0] expected_data;
        input expected_endofpacket;
        input expected_startofpacket;
        input expected_valid;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_endofpacket === (expected_endofpacket ^ endofpacket ^ expected_endofpacket) &&
                expected_startofpacket === (expected_startofpacket ^ startofpacket ^ expected_startofpacket) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data=%h, endofpacket=%b, startofpacket=%b, valid=%b",
                         data, endofpacket, startofpacket, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, endofpacket=%b, startofpacket=%b, valid=%b",
                         expected_data, expected_endofpacket, expected_startofpacket, expected_valid);
                $display("  Got:      data=%h, endofpacket=%b, startofpacket=%b, valid=%b",
                         data, endofpacket, startofpacket, valid);
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
        $dumpvars(0,FRAME_VALID, LINE_VALID, PIXEL_DATA, clk, ready, reset, data, endofpacket, startofpacket, valid);
    end

endmodule
