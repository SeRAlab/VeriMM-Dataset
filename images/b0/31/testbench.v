`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Address;
    reg MemRead;
    reg MemWrite;
    reg [31:0] WriteData;
    reg clk;
    wire [31:0] ReadData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .WriteData(WriteData),
        .clk(clk),
        .ReadData(ReadData)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Address = 0;
            MemRead = 0;
            MemWrite = 0;
            WriteData = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            Address = 32'h0;
            WriteData = 32'h12345678;
            MemWrite = 1;
            @(posedge clk);
            #1 MemWrite = 0;


            MemRead = 1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            Address = 32'd124;
            WriteData = 32'hABCDEF01;
            MemWrite = 1;
            @(posedge clk);
            #1 MemWrite = 0;


            MemRead = 1;
            #1;

            check_outputs(32'hABCDEF01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            Address = 32'd4;
            WriteData = 32'h55AA55AA;
            MemWrite = 1;
            @(posedge clk);
            #1 MemWrite = 0;


            Address = 32'd7;
            MemRead = 1;
            #1;

            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            Address = 32'd8;
            WriteData = 32'h11111111;
            MemWrite = 1;
            @(posedge clk);
            #1;


            WriteData = 32'hEEEEEEEE;
            MemWrite = 0;
            @(posedge clk);
            #1;


            MemRead = 1;
            #1;

            check_outputs(32'h11111111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            Address = 32'd40;
            WriteData = 32'hBEEFCAFE;
            MemWrite = 1;
            @(posedge clk);
            #1;


            Address = 32'd44;
            WriteData = 32'hDEADBEEF;
            MemWrite = 1;
            @(posedge clk);
            #1;


            Address = 32'd40;
            MemWrite = 0;
            MemRead = 1;
            #1;

            check_outputs(32'hBEEFCAFE);
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
        input [31:0] expected_ReadData;
        begin
            if (expected_ReadData === (expected_ReadData ^ ReadData ^ expected_ReadData)) begin
                $display("PASS");
                $display("  Outputs: ReadData=%h",
                         ReadData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ReadData=%h",
                         expected_ReadData);
                $display("  Got:      ReadData=%h",
                         ReadData);
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
        $dumpvars(0,Address, MemRead, MemWrite, WriteData, clk, ReadData);
    end

endmodule
