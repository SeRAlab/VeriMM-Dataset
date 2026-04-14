`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] code;
    reg rd_enable;
    wire [7:0] BCD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .code(code),
        .rd_enable(rd_enable),
        .BCD(BCD)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        code = 4'd0;
        rd_enable = 1'b0;
        @(posedge clock);
        #2;
    end
        endtask
    task testcase001;

    begin
        $display("Test Case 001: code=0, rd_enable=1");
        reset_dut();
        code = 4'd0;
        rd_enable = 1'b1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: code=5, rd_enable=1");
        reset_dut();
        code = 4'd5;
        rd_enable = 1'b1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: code=9, rd_enable=1");
        reset_dut();
        code = 4'd9;
        rd_enable = 1'b1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'h09);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: code=10, rd_enable=1");
        reset_dut();
        code = 4'd10;
        rd_enable = 1'b1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: code=13, rd_enable=1");
        reset_dut();
        code = 4'd13;
        rd_enable = 1'b1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'h13);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: code=15, rd_enable=1");
        reset_dut();
        code = 4'd15;
        rd_enable = 1'b1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'h15);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: code=7, rd_enable=0");
        reset_dut();

        code = 4'd0;
        rd_enable = 1'b1;
        @(posedge clock);
        #2;

        code = 4'd7;
        rd_enable = 1'b0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'h00);
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
        testcase007();
        
        
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
        input [7:0] expected_BCD;
        begin
            if (expected_BCD === (expected_BCD ^ BCD ^ expected_BCD)) begin
                $display("PASS");
                $display("  Outputs: BCD=%h",
                         BCD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD=%h",
                         expected_BCD);
                $display("  Got:      BCD=%h",
                         BCD);
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
        $dumpvars(0,clock, code, rd_enable, BCD);
    end

endmodule
