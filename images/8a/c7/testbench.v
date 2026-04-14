`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [1:0] reg_write_address;
    reg [31:0] reg_write_data;
    reg [1:0] reg_write_enable;
    reg reset;
    wire [31:0] hi_register;
    wire [31:0] lo_register;
    wire [31:0] reg_read_data_1;
    wire [31:0] reg_read_data_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reg_write_address(reg_write_address),
        .reg_write_data(reg_write_data),
        .reg_write_enable(reg_write_enable),
        .reset(reset),
        .hi_register(hi_register),
        .lo_register(lo_register),
        .reg_read_data_1(reg_read_data_1),
        .reg_read_data_2(reg_read_data_2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            reg_write_enable = 2'b00;
            reg_write_address = 2'b00;
            reg_write_data = 32'h0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State Verification");
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write to Register 0");
            reset_dut();
            reg_write_enable = 2'b01;
            reg_write_address = 2'b00;
            reg_write_data = 32'hDEADBEEF;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write to Register 1");
            reset_dut();
            reg_write_enable = 2'b01;
            reg_write_address = 2'b01;
            reg_write_data = 32'hCAFEBABE;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 32'hCAFEBABE);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write to HI/LO Registers");
            reset_dut();
            reg_write_enable = 2'b10;
            reg_write_data = 32'h12345678;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h00001234, 32'h00005678, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Simultaneous RF and HI/LO Write");
            reset_dut();
            reg_write_enable = 2'b11;
            reg_write_address = 2'b00;
            reg_write_data = 32'hAAAA_BBBB;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h0000AAAA, 32'h0000BBBB, 32'hAAAABBBB, 32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify Write to Registers 2 and 3 doesn't affect 0/1");
            reset_dut();

            reg_write_enable = 2'b01;
            reg_write_address = 2'b10;
            reg_write_data = 32'h88888888;
            @(posedge clock);
            #1;

            reg_write_address = 2'b11;
            reg_write_data = 32'h99999999;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
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
        input [31:0] expected_hi_register;
        input [31:0] expected_lo_register;
        input [31:0] expected_reg_read_data_1;
        input [31:0] expected_reg_read_data_2;
        begin
            if (expected_hi_register === (expected_hi_register ^ hi_register ^ expected_hi_register) &&
                expected_lo_register === (expected_lo_register ^ lo_register ^ expected_lo_register) &&
                expected_reg_read_data_1 === (expected_reg_read_data_1 ^ reg_read_data_1 ^ expected_reg_read_data_1) &&
                expected_reg_read_data_2 === (expected_reg_read_data_2 ^ reg_read_data_2 ^ expected_reg_read_data_2)) begin
                $display("PASS");
                $display("  Outputs: hi_register=%h, lo_register=%h, reg_read_data_1=%h, reg_read_data_2=%h",
                         hi_register, lo_register, reg_read_data_1, reg_read_data_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hi_register=%h, lo_register=%h, reg_read_data_1=%h, reg_read_data_2=%h",
                         expected_hi_register, expected_lo_register, expected_reg_read_data_1, expected_reg_read_data_2);
                $display("  Got:      hi_register=%h, lo_register=%h, reg_read_data_1=%h, reg_read_data_2=%h",
                         hi_register, lo_register, reg_read_data_1, reg_read_data_2);
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
        $dumpvars(0,clock, reg_write_address, reg_write_data, reg_write_enable, reset, hi_register, lo_register, reg_read_data_1, reg_read_data_2);
    end

endmodule
