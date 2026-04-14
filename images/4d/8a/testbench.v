`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] ALUOutIn;
    reg [15:0] RemainderIn;
    reg Stall;
    reg [15:0] WriteDataIn;
    reg clk;
    reg rst;
    wire [15:0] ALUOutOut;
    wire [15:0] RemainderOut;
    wire [15:0] WriteDataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOutIn(ALUOutIn),
        .RemainderIn(RemainderIn),
        .Stall(Stall),
        .WriteDataIn(WriteDataIn),
        .clk(clk),
        .rst(rst),
        .ALUOutOut(ALUOutOut),
        .RemainderOut(RemainderOut),
        .WriteDataOut(WriteDataOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Stall = 0;
            ALUOutIn = 16'h0;
            RemainderIn = 16'h0;
            WriteDataIn = 16'h0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Data Load", test_num);
            reset_dut();

            RemainderIn = 16'hAAAA;
            ALUOutIn = 16'hBBBB;
            WriteDataIn = 16'hCCCC;
            Stall = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hBBBB, 16'hAAAA, 16'hCCCC);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Stall Functionality", test_num);
            reset_dut();


            RemainderIn = 16'h1111;
            ALUOutIn = 16'h2222;
            WriteDataIn = 16'h3333;
            Stall = 0;
            @(posedge clk);
            #2;


            Stall = 1;
            RemainderIn = 16'hFFFF;
            ALUOutIn = 16'hFFFF;
            WriteDataIn = 16'hFFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h2222, 16'h1111, 16'h3333);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reset Priority", test_num);
            reset_dut();

            RemainderIn = 16'h1234;
            ALUOutIn = 16'h5678;
            WriteDataIn = 16'h9ABC;
            rst = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Stall Recovery", test_num);
            reset_dut();


            Stall = 1;
            RemainderIn = 16'hAAAA;
            ALUOutIn = 16'hBBBB;
            WriteDataIn = 16'hCCCC;
            @(posedge clk);
            #2;


            Stall = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(16'hBBBB, 16'hAAAA, 16'hCCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multi-cycle Data Flow", test_num);
            reset_dut();


            RemainderIn = 16'h1010;
            ALUOutIn = 16'h2020;
            WriteDataIn = 16'h3030;
            @(posedge clk);
            #2;


            RemainderIn = 16'h4040;
            ALUOutIn = 16'h5050;
            WriteDataIn = 16'h6060;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h5050, 16'h4040, 16'h6060);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reset during Stall", test_num);
            reset_dut();


            RemainderIn = 16'hDADA;
            ALUOutIn = 16'hDADA;
            WriteDataIn = 16'hDADA;
            @(posedge clk);
            #2;


            Stall = 1;
            rst = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000);
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
        input [15:0] expected_ALUOutOut;
        input [15:0] expected_RemainderOut;
        input [15:0] expected_WriteDataOut;
        begin
            if (expected_ALUOutOut === (expected_ALUOutOut ^ ALUOutOut ^ expected_ALUOutOut) &&
                expected_RemainderOut === (expected_RemainderOut ^ RemainderOut ^ expected_RemainderOut) &&
                expected_WriteDataOut === (expected_WriteDataOut ^ WriteDataOut ^ expected_WriteDataOut)) begin
                $display("PASS");
                $display("  Outputs: ALUOutOut=%h, RemainderOut=%h, WriteDataOut=%h",
                         ALUOutOut, RemainderOut, WriteDataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOutOut=%h, RemainderOut=%h, WriteDataOut=%h",
                         expected_ALUOutOut, expected_RemainderOut, expected_WriteDataOut);
                $display("  Got:      ALUOutOut=%h, RemainderOut=%h, WriteDataOut=%h",
                         ALUOutOut, RemainderOut, WriteDataOut);
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
        $dumpvars(0,ALUOutIn, RemainderIn, Stall, WriteDataIn, clk, rst, ALUOutOut, RemainderOut, WriteDataOut);
    end

endmodule
