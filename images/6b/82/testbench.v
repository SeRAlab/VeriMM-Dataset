`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg memRead;
    reg memWrite;
    reg [31:0] writeData;
    wire [31:0] readDataMem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .memRead(memRead),
        .memWrite(memWrite),
        .writeData(writeData),
        .readDataMem(readDataMem)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 0;
            memRead = 0;
            memWrite = 0;
            writeData = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            address = 32'h0000_0004;
            writeData = 32'hAAAA_BBBB;
            memWrite = 1;
            memRead = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            address = 32'h0000_0010;
            writeData = 32'h1234_5678;
            memWrite = 1;
            @(posedge clk);
            #2;


            memWrite = 0;
            memRead = 1;
            address = 32'h0000_0010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            address = 32'h0000_00A0;
            writeData = 32'hCAFE_BABE;
            memWrite = 1;
            @(posedge clk);
            #2;


            address = 32'h0000_00B0;
            writeData = 32'hDEAD_BEEF;
            memWrite = 1;
            @(posedge clk);
            #2;


            address = 32'h0000_00A0;
            memWrite = 0;
            memRead = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            address = 32'h0000_00CC;
            writeData = 32'h1111_1111;
            memWrite = 1;
            @(posedge clk);
            #2;


            address = 32'h0000_00CC;
            writeData = 32'h2222_2222;
            memWrite = 1;
            @(posedge clk);
            #2;


            memWrite = 0;
            memRead = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            address = 32'hFFFF_FFFC;
            writeData = 32'h55AA_55AA;
            memWrite = 1;
            @(posedge clk);
            #2;

            memWrite = 0;
            memRead = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h55AA_55AA);
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
        input [31:0] expected_readDataMem;
        begin
            if (expected_readDataMem === (expected_readDataMem ^ readDataMem ^ expected_readDataMem)) begin
                $display("PASS");
                $display("  Outputs: readDataMem=%h",
                         readDataMem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readDataMem=%h",
                         expected_readDataMem);
                $display("  Got:      readDataMem=%h",
                         readDataMem);
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
        $dumpvars(0,address, clk, memRead, memWrite, writeData, readDataMem);
    end

endmodule
