`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUOutE;
    reg [31:0] WriteDataE;
    reg clk;
    reg [31:0] instrE;
    reg [31:0] pcplusE;
    reg rst;
    wire [31:0] ALUOutM;
    wire [31:0] WriteDataM;
    wire [31:0] instrM;
    wire [31:0] pcplusM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOutE(ALUOutE),
        .WriteDataE(WriteDataE),
        .clk(clk),
        .instrE(instrE),
        .pcplusE(pcplusE),
        .rst(rst),
        .ALUOutM(ALUOutM),
        .WriteDataM(WriteDataM),
        .instrM(instrM),
        .pcplusM(pcplusM)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        instrE = 32'h0;
        ALUOutE = 32'h0;
        WriteDataE = 32'h0;
        pcplusE = 32'h0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Reset Check");
        reset_dut();

        instrE = 32'hFFFFFFFF;
        @(negedge clk);
        #1;

        check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Normal Data Capture");
        reset_dut();
        instrE = 32'h00842023;
        ALUOutE = 32'h10000008;
        WriteDataE = 32'hAAAA5555;
        pcplusE = 32'h00400004;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h10000008, 32'hAAAA5555, 32'h00842023, 32'h00400004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: All Ones Pattern");
        reset_dut();
        instrE = 32'hFFFFFFFF;
        ALUOutE = 32'hFFFFFFFF;
        WriteDataE = 32'hFFFFFFFF;
        pcplusE = 32'hFFFFFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Sequential Updates");
        reset_dut();


        instrE = 32'h11111111; ALUOutE = 32'h22222222;
        WriteDataE = 32'h33333333; pcplusE = 32'h44444444;
        @(posedge clk);


        #1;
        instrE = 32'h55555555; ALUOutE = 32'h66666666;
        WriteDataE = 32'h77777777; pcplusE = 32'h88888888;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h66666666, 32'h77777777, 32'h55555555, 32'h88888888);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Reset Priority during Data Input");
        reset_dut();

        rst = 1;
        instrE = 32'hABCDEF01; ALUOutE = 32'h01234567;
        WriteDataE = 32'h89ABCDEF; pcplusE = 32'h11223344;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
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
        input [31:0] expected_ALUOutM;
        input [31:0] expected_WriteDataM;
        input [31:0] expected_instrM;
        input [31:0] expected_pcplusM;
        begin
            if (expected_ALUOutM === (expected_ALUOutM ^ ALUOutM ^ expected_ALUOutM) &&
                expected_WriteDataM === (expected_WriteDataM ^ WriteDataM ^ expected_WriteDataM) &&
                expected_instrM === (expected_instrM ^ instrM ^ expected_instrM) &&
                expected_pcplusM === (expected_pcplusM ^ pcplusM ^ expected_pcplusM)) begin
                $display("PASS");
                $display("  Outputs: ALUOutM=%h, WriteDataM=%h, instrM=%h, pcplusM=%h",
                         ALUOutM, WriteDataM, instrM, pcplusM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOutM=%h, WriteDataM=%h, instrM=%h, pcplusM=%h",
                         expected_ALUOutM, expected_WriteDataM, expected_instrM, expected_pcplusM);
                $display("  Got:      ALUOutM=%h, WriteDataM=%h, instrM=%h, pcplusM=%h",
                         ALUOutM, WriteDataM, instrM, pcplusM);
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
        $dumpvars(0,ALUOutE, WriteDataE, clk, instrE, pcplusE, rst, ALUOutM, WriteDataM, instrM, pcplusM);
    end

endmodule
