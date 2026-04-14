`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] readReg1;
    reg [3:0] readReg2;
    reg regWrite;
    reg reset;
    reg [31:0] writeData;
    reg [3:0] writeReg;
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
        .reset(reset),
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
            reset = 1;
            regWrite = 0;
            writeReg = 0;
            writeData = 0;
            readReg1 = 0;
            readReg2 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();
            readReg1 = 4'd5;
            readReg2 = 4'd12;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write/Read", test_num);
            reset_dut();


            @(negedge clk);
            regWrite = 1;
            writeReg = 4'd3;
            writeData = 32'hDEADBEEF;
            @(posedge clk);
            #1 regWrite = 0;


            readReg1 = 4'd3;
            readReg2 = 4'd3;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Dual Port Read", test_num);
            reset_dut();


            @(negedge clk);
            regWrite = 1;
            writeReg = 4'd1;
            writeData = 32'h11112222;
            @(posedge clk);


            @(negedge clk);
            writeReg = 4'd15;
            writeData = 32'hAAAA_BBBB;
            @(posedge clk);
            #1 regWrite = 0;


            readReg1 = 4'd1;
            readReg2 = 4'd15;
            #1;
            #1;

            check_outputs(32'h11112222, 32'hAAAA_BBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Check", test_num);
            reset_dut();


            @(negedge clk);
            regWrite = 1;
            writeReg = 4'd7;
            writeData = 32'h55555555;
            @(posedge clk);


            @(negedge clk);
            regWrite = 0;
            writeReg = 4'd7;
            writeData = 32'hFFFFFFFF;
            @(posedge clk);


            readReg1 = 4'd7;
            readReg2 = 4'd0;
            #1;
            #1;

            check_outputs(32'h55555555, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwrite Check", test_num);
            reset_dut();


            @(negedge clk);
            regWrite = 1;
            writeReg = 4'd10;
            writeData = 32'h12340000;
            @(posedge clk);


            @(negedge clk);
            writeReg = 4'd10;
            writeData = 32'h00004321;
            @(posedge clk);
            #1 regWrite = 0;

            readReg1 = 4'd10;
            readReg2 = 4'd10;
            #1;
            #1;

            check_outputs(32'h00004321, 32'h00004321);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary Address Check", test_num);
            reset_dut();


            @(negedge clk);
            regWrite = 1;
            writeReg = 4'd0;
            writeData = 32'hF0F0F0F0;
            @(posedge clk);


            @(negedge clk);
            writeReg = 4'd15;
            writeData = 32'h0F0F0F0F;
            @(posedge clk);
            #1 regWrite = 0;

            readReg1 = 4'd0;
            readReg2 = 4'd15;
            #1;
            #1;

            check_outputs(32'hF0F0F0F0, 32'h0F0F0F0F);
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
        $dumpvars(0,clk, readReg1, readReg2, regWrite, reset, writeData, writeReg, readData1, readData2);
    end

endmodule
