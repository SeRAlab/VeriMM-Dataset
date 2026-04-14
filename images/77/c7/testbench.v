`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg memRead;
    reg memWrite;
    reg [31:0] writeData;
    wire [31:0] readData;

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
            addr = 32'h0;
            writeData = 32'h0;
            memWrite = 1'b0;
            memRead = 1'b0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Writing and Reading from Address 15");


            addr = 32'd15;
            writeData = 32'hABCD1234;
            memWrite = 1'b1;
            memRead = 1'b0;
            @(posedge clk);
            #2;


            memWrite = 1'b0;
            memRead = 1'b1;
            addr = 32'd15;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hABCD1234);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Boundary Check - Address 255");


            addr = 32'd255;
            writeData = 32'hFFFFFFFF;
            memWrite = 1'b1;
            memRead = 1'b0;
            @(posedge clk);
            #2;


            memWrite = 1'b0;
            memRead = 1'b1;
            addr = 32'd255;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Check if readData is 0 when memRead is inactive");


            addr = 32'd50;
            writeData = 32'h55AA55AA;
            memWrite = 1'b1;
            memRead = 1'b0;
            @(posedge clk);
            #2;


            memWrite = 1'b0;
            memRead = 1'b0;
            addr = 32'd50;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Verifying data overwrite at same address");


            addr = 32'd100;
            writeData = 32'h11111111;
            memWrite = 1'b1;
            @(posedge clk);
            #2;


            writeData = 32'hEEEEEEEE;
            @(posedge clk);
            #2;


            memWrite = 1'b0;
            memRead = 1'b1;
            addr = 32'd100;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hEEEEEEEE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Boundary Check - Address 0");


            addr = 32'd0;
            writeData = 32'hCAFEBABE;
            memWrite = 1'b1;
            memRead = 1'b0;
            @(posedge clk);
            #2;


            memWrite = 1'b0;
            memRead = 1'b1;
            addr = 32'd0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_readData;
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
        $dumpvars(0,addr, clk, memRead, memWrite, writeData, readData);
    end

endmodule
