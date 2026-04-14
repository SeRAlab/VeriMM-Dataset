`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] PC;
    reg clock_in;
    reg [4:0] readReg1;
    reg [4:0] readReg2;
    reg regWrite;
    reg rst;
    reg [1:0] switch;
    reg [31:0] writeData;
    reg [4:0] writeReg;
    wire [7:0] led;
    wire [31:0] readData1;
    wire [31:0] readData2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC(PC),
        .clock_in(clock_in),
        .readReg1(readReg1),
        .readReg2(readReg2),
        .regWrite(regWrite),
        .rst(rst),
        .switch(switch),
        .writeData(writeData),
        .writeReg(writeReg),
        .led(led),
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
        rst = 1;
        PC = 0;
        readReg1_bus = 0;
        readReg2_bus = 0;
        writeReg = 0;
        regWrite = 0;
        writeData = 0;
        switch = 0;
        #20;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Verification", test_num);
        reset_dut();


        readReg1_bus[25:21] = 5;
        readReg2_bus[20:16] = 10;
        switch = 0;
        PC = 32'h12345678;

        #10;
        #1;

        check_outputs(8'h78, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read", test_num);
        reset_dut();


        @(posedge clock_in);
        regWrite = 1;
        writeReg = 5'd1;
        writeData = 32'hAAAA_BBBB;


        @(posedge clock_in);
        writeReg = 5'd2;
        writeData = 32'hCCCC_DDDD;

        @(posedge clock_in);
        regWrite = 0;


        readReg1_bus[25:21] = 5'd1;
        readReg2_bus[20:16] = 5'd2;
        switch = 1;

        #10;
        #1;

        check_outputs(8'hBB, 32'hAAAA_BBBB, 32'hCCCC_DDDD);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: regWrite Enable Logic", test_num);
        reset_dut();


        @(posedge clock_in);
        regWrite = 0;
        writeReg = 5'd10;
        writeData = 32'hFFFF_FFFF;

        @(posedge clock_in);

        readReg1_bus[25:21] = 5'd10;
        readReg2_bus[20:16] = 5'd0;
        switch = 1;

        #10;

        #1;


        check_outputs(8'h00, 32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Switch Mechanism", test_num);
        reset_dut();

        PC = 32'h11223344;

        @(posedge clock_in);
        regWrite = 1;
        writeReg = 5'd15;
        writeData = 32'h55667788;

        @(posedge clock_in);
        regWrite = 0;
        readReg1_bus[25:21] = 5'd15;
        readReg2_bus[20:16] = 5'd0;


        switch = 2'b00;
        #5;
        if (led !== 8'h44) $display("Switch 00 failed");


        switch = 2'b01;
        #5;

        #1;


        check_outputs(8'h88, 32'h55667788, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Register 31 and Multi-port", test_num);
        reset_dut();


        @(posedge clock_in);
        regWrite = 1;
        writeReg = 5'd31;
        writeData = 32'h1234_5678;

        @(posedge clock_in);
        regWrite = 0;
        readReg1_bus[25:21] = 5'd31;
        readReg2_bus[20:16] = 5'd31;
        switch = 2'b10;

        #10;
        #1;

        check_outputs(8'h78, 32'h1234_5678, 32'h1234_5678);
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
        input [7:0] expected_led;
        input [31:0] expected_readData1;
        input [31:0] expected_readData2;
        begin
            if (expected_led === (expected_led ^ led ^ expected_led) &&
                expected_readData1 === (expected_readData1 ^ readData1 ^ expected_readData1) &&
                expected_readData2 === (expected_readData2 ^ readData2 ^ expected_readData2)) begin
                $display("PASS");
                $display("  Outputs: led=%h, readData1=%h, readData2=%h",
                         led, readData1, readData2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h, readData1=%h, readData2=%h",
                         expected_led, expected_readData1, expected_readData2);
                $display("  Got:      led=%h, readData1=%h, readData2=%h",
                         led, readData1, readData2);
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
        $dumpvars(0,PC, clock_in, readReg1, readReg2, regWrite, rst, switch, writeData, writeReg, led, readData1, readData2);
    end

endmodule
