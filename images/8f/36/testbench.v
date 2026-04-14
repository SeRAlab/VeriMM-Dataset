`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock_in;
    reg [4:0] readReg1;
    reg [4:0] readReg2;
    reg regWrite;
    reg [31:0] writeData;
    reg [4:0] writeReg;
    wire [31:0] readData1;
    wire [31:0] readData2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_in(clock_in),
        .readReg1(readReg1),
        .readReg2(readReg2),
        .regWrite(regWrite),
        .writeData(writeData),
        .writeReg(writeReg),
        .readData1(readData1),
        .readData2(readData2)
    );

    // Clock generation (10ns period)
    initial begin
        clock_in = 0;
        forever #5 clock_in = ~clock_in;
    end

        task reset_dut;

    begin
        regWrite = 0;
        readReg1 = 0;
        readReg2 = 0;
        writeReg = 0;
        writeData = 0;
        @(posedge clock_in);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Basic Write and Read (Reg 1)");


        @(negedge clock_in);
        regWrite = 1;
        writeReg = 5'd1;
        writeData = 32'hA5A5_B6B6;


        @(negedge clock_in);
        regWrite = 0;


        readReg1 = 5'd1;
        readReg2 = 5'd0;


        @(posedge clock_in);
        #2;
        #1;

        check_outputs(32'hA5A5_B6B6, 32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase 002: Simultaneous Dual Read (Reg 10 and 20)");


        @(negedge clock_in);
        regWrite = 1; writeReg = 5'd10; writeData = 32'h1234_5678;
        @(negedge clock_in);

        regWrite = 1; writeReg = 5'd20; writeData = 32'hDEAD_BEEF;
        @(negedge clock_in);
        regWrite = 0;


        readReg1 = 5'd10;
        readReg2 = 5'd20;

        @(posedge clock_in);
        #2;
        #1;

        check_outputs(32'h1234_5678, 32'hDEAD_BEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase 003: Verify regWrite signal (Write Enable)");


        @(negedge clock_in);
        regWrite = 1; writeReg = 5'd5; writeData = 32'hCAFE_BABE;
        @(negedge clock_in);


        regWrite = 0; writeReg = 5'd5; writeData = 32'hFFFF_FFFF;
        @(negedge clock_in);


        readReg1 = 5'd5;
        readReg2 = 5'd0;
        @(posedge clock_in);
        #2;
        #1;

        check_outputs(32'hCAFE_BABE, 32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase 004: Boundary Check (Register 31)");

        @(negedge clock_in);
        regWrite = 1; writeReg = 5'd31; writeData = 32'h8765_4321;
        @(negedge clock_in);
        regWrite = 0;
        readReg1 = 5'd31;
        readReg2 = 5'd31;

        @(posedge clock_in);
        #2;
        #1;

        check_outputs(32'h8765_4321, 32'h8765_4321);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase 005: Same Cycle Read/Write (Check for non-forwarding behavior)");


        @(negedge clock_in);
        regWrite = 1; writeReg = 5'd7; writeData = 32'h0000_1111;
        @(negedge clock_in);


        regWrite = 1; writeReg = 5'd7; writeData = 32'h0000_2222;
        readReg1 = 5'd7;

        @(posedge clock_in);
        #2;


        #1;



        check_outputs(32'h0000_1111, 32'h0000_0000);
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
        input [31:0] expected_readData1;
        input [31:0] expected_readData2;
        begin
            if (expected_readData1 === (expected_readData1 ^ readData1 ^ expected_readData1) &&
                expected_readData2 === (expected_readData2 ^ readData2 ^ expected_readData2)) begin
                $display("PASS");
                $display("  Outputs: readData1=%h, readData2=%h",
                         readData1, readData2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readData1=%h, readData2=%h",
                         expected_readData1, expected_readData2);
                $display("  Got:      readData1=%h, readData2=%h",
                         readData1, readData2);
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
        $dumpvars(0,clock_in, readReg1, readReg2, regWrite, writeData, writeReg, readData1, readData2);
    end

endmodule
