`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
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
        .clk(clk),
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
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            regWrite = 0;
            readReg1 = 0;
            readReg2 = 0;
            writeReg = 0;
            writeData = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read to Reg 1");
            reset_dut();


            regWrite = 1;
            writeReg = 5'd1;
            writeData = 32'h12345678;
            @(posedge clk);
            #1;


            regWrite = 0;
            readReg1 = 5'd1;
            readReg2 = 5'd0;
            #2;

            #1;


            check_outputs(32'h12345678, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Simultaneous Read of R10 and R20");
            reset_dut();


            regWrite = 1;
            writeReg = 5'd10;
            writeData = 32'hAAAAAAAA;
            @(posedge clk);
            #1;


            writeReg = 5'd20;
            writeData = 32'h55555555;
            @(posedge clk);
            #1;


            regWrite = 0;
            readReg1 = 5'd10;
            readReg2 = 5'd20;
            #2;

            #1;


            check_outputs(32'hAAAAAAAA, 32'h55555555);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Verify regWrite signal prevents writing");
            reset_dut();


            regWrite = 0;
            writeReg = 5'd15;
            writeData = 32'hDEADBEEF;
            @(posedge clk);
            #1;


            readReg1 = 5'd15;
            readReg2 = 5'd0;
            #2;

            #1;


            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write/Read from Register 31");
            reset_dut();

            regWrite = 1;
            writeReg = 5'd31;
            writeData = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            regWrite = 0;
            readReg1 = 5'd31;
            readReg2 = 5'd31;
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwrite existing register value");
            reset_dut();


            regWrite = 1;
            writeReg = 5'd2;
            writeData = 32'h11111111;
            @(posedge clk);
            #1;


            writeData = 32'h22222222;
            @(posedge clk);
            #1;

            regWrite = 0;
            readReg1 = 5'd2;
            readReg2 = 5'd0;
            #2;

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
        $dumpvars(0,clk, readReg1, readReg2, regWrite, writeData, writeReg, readData1, readData2);
    end

endmodule
