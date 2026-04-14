`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clock;
    reg i_data;
    reg reset;
    wire [7:0] scan_code;
    wire scan_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clock(i_clock),
        .i_data(i_data),
        .reset(reset),
        .scan_code(scan_code),
        .scan_ready(scan_ready)
    );

    // Clock generation (10ns period)
    initial begin
        i_clock = 0;
        forever #5 i_clock = ~i_clock;
    end

        task reset_dut;

    begin
        reset = 1;
        i_data = 1;
        repeat(3) @(posedge i_clock);
        reset = 0;
        repeat(2) @(posedge i_clock);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Sending Scan Code 0x1C...", test_num);
        reset_dut();
        send_ps2_byte(8'h1C);
        #1;

        check_outputs(8'h1C, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Sending Scan Code 0x21...", test_num);
        reset_dut();
        send_ps2_byte(8'h21);
        #1;

        check_outputs(8'h21, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Sending Break Code 0xF0...", test_num);
        reset_dut();
        send_ps2_byte(8'hF0);
        #1;

        check_outputs(8'hF0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Sending POST Success 0xAA...", test_num);
        reset_dut();
        send_ps2_byte(8'hAA);
        #1;

        check_outputs(8'hAA, 1'b1);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Test Case %0d: Checking outputs mid-transmission...", test_num);
        reset_dut();

        @(posedge i_clock) i_data = 0;

        for (i = 0; i < 4; i = i + 1) begin
            @(posedge i_clock) i_data = 1;
        end
        @(negedge i_clock);
        #2;

        #1;


        check_outputs(scan_code, 1'b0);
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
        input [7:0] expected_scan_code;
        input expected_scan_ready;
        begin
            if (expected_scan_code === (expected_scan_code ^ scan_code ^ expected_scan_code) &&
                expected_scan_ready === (expected_scan_ready ^ scan_ready ^ expected_scan_ready)) begin
                $display("PASS");
                $display("  Outputs: scan_code=%h, scan_ready=%b",
                         scan_code, scan_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scan_code=%h, scan_ready=%b",
                         expected_scan_code, expected_scan_ready);
                $display("  Got:      scan_code=%h, scan_ready=%b",
                         scan_code, scan_ready);
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
        $dumpvars(0,i_clock, i_data, reset, scan_code, scan_ready);
    end

endmodule
