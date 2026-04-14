`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] aluOut;
    reg clock;
    reg debugEnable;
    reg debugReset;
    reg eop;
    reg memToReg;
    reg [31:0] memoryOut;
    reg regWrite;
    reg reset;
    reg [4:0] writeRegister;
    wire [31:0] aluOutOut;
    wire eopOut;
    wire memToRegOut;
    wire [31:0] memoryOutOut;
    wire regWriteOut;
    wire [4:0] writeRegisterOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluOut(aluOut),
        .clock(clock),
        .debugEnable(debugEnable),
        .debugReset(debugReset),
        .eop(eop),
        .memToReg(memToReg),
        .memoryOut(memoryOut),
        .regWrite(regWrite),
        .reset(reset),
        .writeRegister(writeRegister),
        .aluOutOut(aluOutOut),
        .eopOut(eopOut),
        .memToRegOut(memToRegOut),
        .memoryOutOut(memoryOutOut),
        .regWriteOut(regWriteOut),
        .writeRegisterOut(writeRegisterOut)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        debugReset = 0;
        debugEnable = 0;
        aluOut = 0;
        memoryOut = 0;
        writeRegister = 0;
        regWrite = 0;
        memToReg = 0;
        eop = 0;
        @(posedge clock);
        #1 reset = 0;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(32'h0, 1'b0, 1'b0, 32'h0, 1'b0, 5'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(negedge clock);
        aluOut = 32'hAAAA_BBBB;
        memoryOut = 32'h1111_2222;
        writeRegister = 5'd15;
        regWrite = 1'b1;
        memToReg = 1'b0;
        eop = 1'b0;
        debugEnable = 1'b1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hAAAA_BBBB, 1'b0, 1'b0, 32'h1111_2222, 1'b1, 5'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(negedge clock);
        aluOut = 32'hCCCC_DDDD;
        memoryOut = 32'hDEAD_BEEF;
        writeRegister = 5'd31;
        regWrite = 1'b1;
        memToReg = 1'b1;
        eop = 1'b1;
        debugEnable = 1'b1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hCCCC_DDDD, 1'b1, 1'b1, 32'hDEAD_BEEF, 1'b1, 5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        @(negedge clock);
        aluOut = 32'hFFFF_FFFF;
        writeRegister = 5'd1;
        regWrite = 1'b1;
        @(posedge clock);
        #1;


        @(negedge clock);
        debugReset = 1'b1;
        @(posedge clock);
        #1;

        #1;


        check_outputs(32'h0, 1'b0, 1'b0, 32'h0, 1'b0, 5'h0);

        @(negedge clock);
        debugReset = 1'b0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        @(negedge clock);
        aluOut = 32'h1;
        writeRegister = 5'd10;
        @(posedge clock);
        #1;


        @(negedge clock);
        aluOut = 32'h2;
        writeRegister = 5'd20;
        @(posedge clock);
        #1;

        #1;


        check_outputs(32'h2, 1'b0, 1'b0, 32'h0, 1'b0, 5'd20);
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
        input [31:0] expected_aluOutOut;
        input expected_eopOut;
        input expected_memToRegOut;
        input [31:0] expected_memoryOutOut;
        input expected_regWriteOut;
        input [4:0] expected_writeRegisterOut;
        begin
            if (expected_aluOutOut === (expected_aluOutOut ^ aluOutOut ^ expected_aluOutOut) &&
                expected_eopOut === (expected_eopOut ^ eopOut ^ expected_eopOut) &&
                expected_memToRegOut === (expected_memToRegOut ^ memToRegOut ^ expected_memToRegOut) &&
                expected_memoryOutOut === (expected_memoryOutOut ^ memoryOutOut ^ expected_memoryOutOut) &&
                expected_regWriteOut === (expected_regWriteOut ^ regWriteOut ^ expected_regWriteOut) &&
                expected_writeRegisterOut === (expected_writeRegisterOut ^ writeRegisterOut ^ expected_writeRegisterOut)) begin
                $display("PASS");
                $display("  Outputs: aluOutOut=%h, eopOut=%b, memToRegOut=%b, memoryOutOut=%h, regWriteOut=%b, writeRegisterOut=%h",
                         aluOutOut, eopOut, memToRegOut, memoryOutOut, regWriteOut, writeRegisterOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluOutOut=%h, eopOut=%b, memToRegOut=%b, memoryOutOut=%h, regWriteOut=%b, writeRegisterOut=%h",
                         expected_aluOutOut, expected_eopOut, expected_memToRegOut, expected_memoryOutOut, expected_regWriteOut, expected_writeRegisterOut);
                $display("  Got:      aluOutOut=%h, eopOut=%b, memToRegOut=%b, memoryOutOut=%h, regWriteOut=%b, writeRegisterOut=%h",
                         aluOutOut, eopOut, memToRegOut, memoryOutOut, regWriteOut, writeRegisterOut);
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
        $dumpvars(0,aluOut, clock, debugEnable, debugReset, eop, memToReg, memoryOut, regWrite, reset, writeRegister, aluOutOut, eopOut, memToRegOut, memoryOutOut, regWriteOut, writeRegisterOut);
    end

endmodule
