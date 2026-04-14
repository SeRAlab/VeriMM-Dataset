`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] aluResEX;
    reg clk;
    reg memReadEX;
    reg memToRegEX;
    reg memWriteEX;
    reg [2:0] rdEX;
    reg [7:0] readData2EX;
    reg regWriteEX;
    reg rst;
    wire [7:0] aluResEXOut;
    wire memReadEXOut;
    wire memToRegEXOut;
    wire memWriteEXOut;
    wire [2:0] rdEXOut;
    wire [7:0] readData2EXOut;
    wire regWriteEXOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluResEX(aluResEX),
        .clk(clk),
        .memReadEX(memReadEX),
        .memToRegEX(memToRegEX),
        .memWriteEX(memWriteEX),
        .rdEX(rdEX),
        .readData2EX(readData2EX),
        .regWriteEX(regWriteEX),
        .rst(rst),
        .aluResEXOut(aluResEXOut),
        .memReadEXOut(memReadEXOut),
        .memToRegEXOut(memToRegEXOut),
        .memWriteEXOut(memWriteEXOut),
        .rdEXOut(rdEXOut),
        .readData2EXOut(readData2EXOut),
        .regWriteEXOut(regWriteEXOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        aluResEX = 0;
        memReadEX = 0;
        memToRegEX = 0;
        memWriteEX = 0;
        rdEX = 0;
        readData2EX = 0;
        regWriteEX = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Data Transfer", test_num);
        reset_dut();


        aluResEX = 8'hA5;
        readData2EX = 8'h5A;
        rdEX = 3'b101;
        memReadEX = 1;
        memWriteEX = 0;
        memToRegEX = 1;
        regWriteEX = 1;

        @(posedge clk);
        #2;


        #1;



        check_outputs(8'hA5, 1, 1, 0, 3'b101, 8'h5A, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Zero Values and Write-Only Control", test_num);
        reset_dut();

        aluResEX = 8'h00;
        readData2EX = 8'h00;
        rdEX = 3'b000;
        memReadEX = 0;
        memWriteEX = 1;
        memToRegEX = 0;
        regWriteEX = 0;

        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h00, 0, 0, 1, 3'b000, 8'h00, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Maximum Values (All 1s)", test_num);
        reset_dut();

        aluResEX = 8'hFF;
        readData2EX = 8'hFF;
        rdEX = 3'b111;
        memReadEX = 1;
        memWriteEX = 1;
        memToRegEX = 1;
        regWriteEX = 1;

        @(posedge clk);
        #2;

        #1;


        check_outputs(8'hFF, 1, 1, 1, 3'b111, 8'hFF, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Reset Mid-Operation", test_num);
        reset_dut();


        aluResEX = 8'h12;
        readData2EX = 8'h34;
        rdEX = 3'b010;
        @(posedge clk);
        #2;


        rst = 1;
        @(posedge clk);
        #2;


        #1;



        check_outputs(8'h00, 0, 0, 0, 3'b000, 8'h00, 0);
        rst = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Data Change Timing", test_num);
        reset_dut();

        aluResEX = 8'hCC;
        readData2EX = 8'h33;
        rdEX = 3'b110;
        memReadEX = 0;
        memWriteEX = 0;
        memToRegEX = 1;
        regWriteEX = 0;

        @(posedge clk);
        #2;


        aluResEX = 8'hEE;
        rdEX = 3'b001;


        #1;



        check_outputs(8'hCC, 0, 1, 0, 3'b110, 8'h33, 0);
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
        input [7:0] expected_aluResEXOut;
        input expected_memReadEXOut;
        input expected_memToRegEXOut;
        input expected_memWriteEXOut;
        input [2:0] expected_rdEXOut;
        input [7:0] expected_readData2EXOut;
        input expected_regWriteEXOut;
        begin
            if (expected_aluResEXOut === (expected_aluResEXOut ^ aluResEXOut ^ expected_aluResEXOut) &&
                expected_memReadEXOut === (expected_memReadEXOut ^ memReadEXOut ^ expected_memReadEXOut) &&
                expected_memToRegEXOut === (expected_memToRegEXOut ^ memToRegEXOut ^ expected_memToRegEXOut) &&
                expected_memWriteEXOut === (expected_memWriteEXOut ^ memWriteEXOut ^ expected_memWriteEXOut) &&
                expected_rdEXOut === (expected_rdEXOut ^ rdEXOut ^ expected_rdEXOut) &&
                expected_readData2EXOut === (expected_readData2EXOut ^ readData2EXOut ^ expected_readData2EXOut) &&
                expected_regWriteEXOut === (expected_regWriteEXOut ^ regWriteEXOut ^ expected_regWriteEXOut)) begin
                $display("PASS");
                $display("  Outputs: aluResEXOut=%h, memReadEXOut=%b, memToRegEXOut=%b, memWriteEXOut=%b, rdEXOut=%h, readData2EXOut=%h, regWriteEXOut=%b",
                         aluResEXOut, memReadEXOut, memToRegEXOut, memWriteEXOut, rdEXOut, readData2EXOut, regWriteEXOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluResEXOut=%h, memReadEXOut=%b, memToRegEXOut=%b, memWriteEXOut=%b, rdEXOut=%h, readData2EXOut=%h, regWriteEXOut=%b",
                         expected_aluResEXOut, expected_memReadEXOut, expected_memToRegEXOut, expected_memWriteEXOut, expected_rdEXOut, expected_readData2EXOut, expected_regWriteEXOut);
                $display("  Got:      aluResEXOut=%h, memReadEXOut=%b, memToRegEXOut=%b, memWriteEXOut=%b, rdEXOut=%h, readData2EXOut=%h, regWriteEXOut=%b",
                         aluResEXOut, memReadEXOut, memToRegEXOut, memWriteEXOut, rdEXOut, readData2EXOut, regWriteEXOut);
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
        $dumpvars(0,aluResEX, clk, memReadEX, memToRegEX, memWriteEX, rdEX, readData2EX, regWriteEX, rst, aluResEXOut, memReadEXOut, memToRegEXOut, memWriteEXOut, rdEXOut, readData2EXOut, regWriteEXOut);
    end

endmodule
