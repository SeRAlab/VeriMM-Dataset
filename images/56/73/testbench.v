`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] aluOut;
    reg clock;
    reg memToReg;
    reg [31:0] memoryOut;
    reg regWrite;
    reg reset;
    reg [4:0] writeRegister;
    wire [31:0] aluOutOut;
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
        .memToReg(memToReg),
        .memoryOut(memoryOut),
        .regWrite(regWrite),
        .reset(reset),
        .writeRegister(writeRegister),
        .aluOutOut(aluOutOut),
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
            @(posedge clock);
            reset = 1;

            writeRegister = 5'b0;
            aluOut = 32'b0;
            memoryOut = 32'b0;
            regWrite = 1'b0;
            memToReg = 1'b0;
            @(negedge clock);
            #1;
            reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0, 32'h0, 1'b0, 5'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ALU Data Capture", test_num);
            reset_dut();


            writeRegister = 5'd5;
            aluOut = 32'hDEADBEEF;
            memoryOut = 32'h0;
            regWrite = 1'b1;
            memToReg = 1'b0;

            @(negedge clock);
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 1'b0, 32'h0, 1'b1, 5'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Memory Load Capture", test_num);
            reset_dut();


            writeRegister = 5'd10;
            aluOut = 32'h00001000;
            memoryOut = 32'hCAFEBABE;
            regWrite = 1'b1;
            memToReg = 1'b1;

            @(negedge clock);
            #2;
            #1;

            check_outputs(32'h00001000, 1'b1, 32'hCAFEBABE, 1'b1, 5'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Disabled RegWrite Capture", test_num);
            reset_dut();


            writeRegister = 5'd0;
            aluOut = 32'hFFFFFFFF;
            memoryOut = 32'h0;
            regWrite = 1'b0;
            memToReg = 1'b0;

            @(negedge clock);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0, 32'h0, 1'b0, 5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Values Capture", test_num);
            reset_dut();

            writeRegister = 5'b11111;
            aluOut = 32'h5555AAAA;
            memoryOut = 32'hAAAA5555;
            regWrite = 1'b1;
            memToReg = 1'b1;

            @(negedge clock);
            #2;
            #1;

            check_outputs(32'h5555AAAA, 1'b1, 32'hAAAA5555, 1'b1, 5'b11111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input Stability Check", test_num);
            reset_dut();


            writeRegister = 5'd1;
            aluOut = 32'h1;
            memoryOut = 32'h1;
            regWrite = 1'b1;
            memToReg = 1'b0;

            @(posedge clock);

            writeRegister = 5'd20;
            aluOut = 32'h87654321;
            memoryOut = 32'h12345678;
            regWrite = 1'b1;
            memToReg = 1'b1;

            @(negedge clock);
            #2;
            #1;

            check_outputs(32'h87654321, 1'b1, 32'h12345678, 1'b1, 5'd20);
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
        input [31:0] expected_aluOutOut;
        input expected_memToRegOut;
        input [31:0] expected_memoryOutOut;
        input expected_regWriteOut;
        input [4:0] expected_writeRegisterOut;
        begin
            if (expected_aluOutOut === (expected_aluOutOut ^ aluOutOut ^ expected_aluOutOut) &&
                expected_memToRegOut === (expected_memToRegOut ^ memToRegOut ^ expected_memToRegOut) &&
                expected_memoryOutOut === (expected_memoryOutOut ^ memoryOutOut ^ expected_memoryOutOut) &&
                expected_regWriteOut === (expected_regWriteOut ^ regWriteOut ^ expected_regWriteOut) &&
                expected_writeRegisterOut === (expected_writeRegisterOut ^ writeRegisterOut ^ expected_writeRegisterOut)) begin
                $display("PASS");
                $display("  Outputs: aluOutOut=%h, memToRegOut=%b, memoryOutOut=%h, regWriteOut=%b, writeRegisterOut=%h",
                         aluOutOut, memToRegOut, memoryOutOut, regWriteOut, writeRegisterOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluOutOut=%h, memToRegOut=%b, memoryOutOut=%h, regWriteOut=%b, writeRegisterOut=%h",
                         expected_aluOutOut, expected_memToRegOut, expected_memoryOutOut, expected_regWriteOut, expected_writeRegisterOut);
                $display("  Got:      aluOutOut=%h, memToRegOut=%b, memoryOutOut=%h, regWriteOut=%b, writeRegisterOut=%h",
                         aluOutOut, memToRegOut, memoryOutOut, regWriteOut, writeRegisterOut);
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
        $dumpvars(0,aluOut, clock, memToReg, memoryOut, regWrite, reset, writeRegister, aluOutOut, memToRegOut, memoryOutOut, regWriteOut, writeRegisterOut);
    end

endmodule
