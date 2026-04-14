`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg init;
    reg [4:0] readReg1;
    reg [4:0] readReg2;
    reg [31:0] writeData;
    reg writeOp;
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
        .init(init),
        .readReg1(readReg1),
        .readReg2(readReg2),
        .writeData(writeData),
        .writeOp(writeOp),
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
        init = 1;
        writeOp = 0;
        readReg1 = 0;
        readReg2 = 0;
        writeReg = 0;
        writeData = 0;
        @(posedge clk);
        #1;
        init = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Initial Reset Check - All registers should be 0", test_num);
        reset_dut();

        readReg1 = 5'd1;
        readReg2 = 5'd31;
        #2;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Single Register Write/Read", test_num);
        reset_dut();
        @(posedge clk);
        writeOp = 1;
        writeReg = 5'd10;
        writeData = 32'hDEADBEEF;
        @(negedge clk);
        #2;
        writeOp = 0;
        readReg1 = 5'd10;
        readReg2 = 5'd0;
        #5;
        #1;

        check_outputs(32'hDEADBEEF, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Register 0 Hardwired to Zero Check", test_num);
        reset_dut();
        @(posedge clk);
        writeOp = 1;
        writeReg = 5'd0;
        writeData = 32'hFFFFFFFF;
        @(negedge clk);
        #2;
        writeOp = 0;
        readReg1 = 5'd0;
        readReg2 = 5'd0;
        #5;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Simultaneous Read of Two Registers", test_num);
        reset_dut();

        @(posedge clk);
        writeOp = 1; writeReg = 5'd5; writeData = 32'h11112222;
        @(negedge clk);

        @(posedge clk);
        writeOp = 1; writeReg = 5'd6; writeData = 32'h33334444;
        @(negedge clk);
        #2;
        writeOp = 0;
        readReg1 = 5'd5;
        readReg2 = 5'd6;
        #5;
        #1;

        check_outputs(32'h11112222, 32'h33334444);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: WriteOp Enable Logic Check", test_num);
        reset_dut();
        @(posedge clk);
        writeOp = 0;
        writeReg = 5'd15;
        writeData = 32'hAAAA5555;
        @(negedge clk);
        #2;
        readReg1 = 5'd15;
        #5;
        #1;

        check_outputs(32'h0, 32'h0);
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
        $dumpvars(0,clk, init, readReg1, readReg2, writeData, writeOp, writeReg, readData1, readData2);
    end

endmodule
