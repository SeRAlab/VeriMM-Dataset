`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] readReg1;
    reg [2:0] readReg2;
    reg [7:0] writeData;
    reg writeEnb;
    reg [2:0] writeReg;
    wire [7:0] readData1;
    wire [7:0] readData2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .readReg1(readReg1),
        .readReg2(readReg2),
        .writeData(writeData),
        .writeEnb(writeEnb),
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
            writeEnb = 0;
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
            reset_dut();
            test_num = 1;
            readReg1 = 3'd0;
            readReg2 = 3'd0;
            #2;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            writeReg = 3'd1;
            writeData = 8'hAA;
            writeEnb = 1;
            @(posedge clk);
            #1;
            writeEnb = 0;

            readReg1 = 3'd1;
            readReg2 = 3'd0;
            #2;
            #1;

            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            writeReg = 3'd0;
            writeData = 8'hFF;
            writeEnb = 1;
            @(posedge clk);
            #1;
            writeEnb = 0;

            readReg1 = 3'd0;
            readReg2 = 3'd0;
            #2;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            writeReg = 3'd2;
            writeData = 8'h55;
            writeEnb = 0;
            @(posedge clk);
            #1;

            readReg1 = 3'd2;
            readReg2 = 3'd0;
            #2;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            writeReg = 3'd3;
            writeData = 8'h33;
            writeEnb = 1;
            @(posedge clk);
            #1;

            writeReg = 3'd7;
            writeData = 8'h77;
            writeEnb = 1;
            @(posedge clk);
            #1;
            writeEnb = 0;

            readReg1 = 3'd3;
            readReg2 = 3'd7;
            #2;
            #1;

            check_outputs(8'h33, 8'h77);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            writeReg = 3'd4;
            writeData = 8'h11;
            writeEnb = 1;
            @(posedge clk);
            #1;

            writeData = 8'hEE;
            @(posedge clk);
            #1;
            writeEnb = 0;
            readReg1 = 3'd4;
            readReg2 = 3'd4;
            #2;
            #1;

            check_outputs(8'hEE, 8'hEE);
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
        input [7:0] expected_readData1;
        input [7:0] expected_readData2;
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
        $dumpvars(0,clk, readReg1, readReg2, writeData, writeEnb, writeReg, readData1, readData2);
    end

endmodule
