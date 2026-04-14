`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [1:0] memRead;
    reg [1:0] memWrite;
    reg rst;
    reg [15:0] writeData;
    wire [15:0] readData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .memRead(memRead),
        .memWrite(memWrite),
        .rst(rst),
        .writeData(writeData),
        .readData(readData)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr = 0;
            memRead = 0;
            memWrite = 0;
            writeData = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            @(posedge clk);
            addr = 16'h0010;
            writeData = 16'hABCD;
            memWrite = 2'b01;
            @(posedge clk);
            memWrite = 2'b00;


            memRead = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            @(posedge clk);
            addr = 16'h0020;
            writeData = 16'h1234;
            memWrite = 2'b01;
            @(posedge clk);
            memWrite = 2'b00;


            memRead = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0034);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            @(posedge clk);
            addr = 16'h0030;
            writeData = 16'hAAAA;
            memWrite = 2'b01;
            @(posedge clk);


            writeData = 16'h0055;
            memWrite = 2'b10;
            @(posedge clk);
            memWrite = 2'b00;


            memRead = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAA55);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            addr = 16'h0000;
            memRead = 2'b01;
            @(posedge clk);
            #1;


            $display("Checking Initialized Memory...");
            #1;

            check_outputs(readData);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            addr = 16'hFFFF;
            writeData = 16'h55AA;
            memWrite = 2'b01;
            @(posedge clk);
            memWrite = 2'b00;

            memRead = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h55AA);
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
        input [15:0] expected_readData;
        begin
            if (expected_readData === (expected_readData ^ readData ^ expected_readData)) begin
                $display("PASS");
                $display("  Outputs: readData=%h",
                         readData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readData=%h",
                         expected_readData);
                $display("  Got:      readData=%h",
                         readData);
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
        $dumpvars(0,addr, clk, memRead, memWrite, rst, writeData, readData);
    end

endmodule
