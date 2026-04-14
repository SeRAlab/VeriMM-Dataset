`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RegWrite;
    reg clk;
    reg [4:0] readReg1;
    reg [4:0] readReg2;
    reg [31:0] writeData;
    wire [31:0] readData1;
    wire [31:0] readData2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegWrite(RegWrite),
        .clk(clk),
        .readReg1(readReg1),
        .readReg2(readReg2),
        .writeData(writeData),
        .readData1(readData1),
        .readData2(readData2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RegWrite = 0;
            readReg1 = 0;
            readReg2 = 0;
            writeData = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running testcase001: Basic Write and Readback (Reg 1)");
            RegWrite = 1;
            readReg1 = 5'd1;
            writeData = 32'hAAAA5555;
            @(posedge clk);
            #1;
            RegWrite = 0;

            #1;


            check_outputs(32'hAAAA5555, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running testcase002: Verify RegWrite Disabled logic");

            RegWrite = 1;
            readReg1 = 5'd2;
            writeData = 32'h0;
            @(posedge clk);
            #1;

            RegWrite = 0;
            readReg1 = 5'd2;
            writeData = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running testcase003: Dual Port Simultaneous Read");

            RegWrite = 1;
            readReg1 = 5'd10;
            writeData = 32'h12345678;
            @(posedge clk);
            #1;

            RegWrite = 1;
            readReg1 = 5'd20;
            writeData = 32'h87654321;
            @(posedge clk);
            #1;

            RegWrite = 0;
            readReg1 = 5'd10;
            readReg2 = 5'd20;
            #1;
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running testcase004: Boundary Register (Reg 31)");
            RegWrite = 1;
            readReg1 = 5'd31;
            writeData = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            RegWrite = 0;
            readReg1 = 5'd31;
            readReg2 = 5'd31;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Running testcase005: Overwrite logic");

            RegWrite = 1;
            readReg1 = 5'd5;
            writeData = 32'h11111111;
            @(posedge clk);
            #1;

            RegWrite = 1;
            readReg1 = 5'd5;
            writeData = 32'h22222222;
            @(posedge clk);
            #1;
            RegWrite = 0;
            readReg1 = 5'd5;
            readReg2 = 5'd0;
            #1;
            #1;

            check_outputs(32'h22222222, 32'h00000000);
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
        $dumpvars(0,RegWrite, clk, readReg1, readReg2, writeData, readData1, readData2);
    end

endmodule
