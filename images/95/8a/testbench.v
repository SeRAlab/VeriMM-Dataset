`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUResIn;
    reg [1:0] WB_IN;
    reg clk;
    reg [4:0] destIn;
    reg [31:0] memReadIn;
    reg rst;
    wire [31:0] ALUResOut;
    wire [1:0] WB_Out;
    wire [4:0] destOut;
    wire [31:0] memReadOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUResIn(ALUResIn),
        .WB_IN(WB_IN),
        .clk(clk),
        .destIn(destIn),
        .memReadIn(memReadIn),
        .rst(rst),
        .ALUResOut(ALUResOut),
        .WB_Out(WB_Out),
        .destOut(destOut),
        .memReadOut(memReadOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ALUResIn = 0;
            WB_IN = 0;
            destIn = 0;
            memReadIn = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Behavior", test_num);
            reset_dut();


            #1;



            check_outputs(32'h0, 2'h0, 5'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Data Transfer", test_num);
            reset_dut();

            WB_IN = 2'b11;
            ALUResIn = 32'hDEADBEEF;
            memReadIn = 32'hCAFEBABE;
            destIn = 5'd15;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 2'b11, 5'd15, 32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Transfer", test_num);
            reset_dut();

            WB_IN = 2'b11;
            ALUResIn = 32'hFFFFFFFF;
            memReadIn = 32'hFFFFFFFF;
            destIn = 5'b11111;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 2'b11, 5'b11111, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Pattern", test_num);
            reset_dut();

            WB_IN = 2'b10;
            ALUResIn = 32'hAAAAAAAA;
            memReadIn = 32'h55555555;
            destIn = 5'b10101;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAAAAAA, 2'b10, 5'b10101, 32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Values after Non-Zero", test_num);
            reset_dut();


            WB_IN = 2'b01;
            ALUResIn = 32'h12345678;
            destIn = 5'd31;
            @(posedge clk);


            WB_IN = 2'b00;
            ALUResIn = 32'h0;
            memReadIn = 32'h0;
            destIn = 5'd0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 2'b00, 5'd0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Overrides Inputs", test_num);
            reset_dut();

            WB_IN = 2'b11;
            ALUResIn = 32'hFFFFFFFF;
            destIn = 5'h1F;
            rst = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 2'h0, 5'h0, 32'h0);
            rst = 0;
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
        input [31:0] expected_ALUResOut;
        input [1:0] expected_WB_Out;
        input [4:0] expected_destOut;
        input [31:0] expected_memReadOut;
        begin
            if (expected_ALUResOut === (expected_ALUResOut ^ ALUResOut ^ expected_ALUResOut) &&
                expected_WB_Out === (expected_WB_Out ^ WB_Out ^ expected_WB_Out) &&
                expected_destOut === (expected_destOut ^ destOut ^ expected_destOut) &&
                expected_memReadOut === (expected_memReadOut ^ memReadOut ^ expected_memReadOut)) begin
                $display("PASS");
                $display("  Outputs: ALUResOut=%h, WB_Out=%h, destOut=%h, memReadOut=%h",
                         ALUResOut, WB_Out, destOut, memReadOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUResOut=%h, WB_Out=%h, destOut=%h, memReadOut=%h",
                         expected_ALUResOut, expected_WB_Out, expected_destOut, expected_memReadOut);
                $display("  Got:      ALUResOut=%h, WB_Out=%h, destOut=%h, memReadOut=%h",
                         ALUResOut, WB_Out, destOut, memReadOut);
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
        $dumpvars(0,ALUResIn, WB_IN, clk, destIn, memReadIn, rst, ALUResOut, WB_Out, destOut, memReadOut);
    end

endmodule
