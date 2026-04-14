`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Branch;
    reg [31:0] ConBA;
    reg [31:0] DataBusA;
    reg [25:0] JT;
    reg [2:0] PCSrc;
    reg PCWrite;
    reg [31:0] PC_In;
    reg clk;
    reg flush;
    reg rst;
    wire [31:0] PC_Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Branch(Branch),
        .ConBA(ConBA),
        .DataBusA(DataBusA),
        .JT(JT),
        .PCSrc(PCSrc),
        .PCWrite(PCWrite),
        .PC_In(PC_In),
        .clk(clk),
        .flush(flush),
        .rst(rst),
        .PC_Out(PC_Out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        flush = 0;
        PCWrite = 0;
        PCSrc = 3'b000;
        Branch = 0;
        ConBA = 32'h0;
        DataBusA = 32'h0;
        JT = 26'h0;
        PC_In = 32'h0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        PCWrite = 1;
        PCSrc = 3'b000;
        Branch = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        PCWrite = 1;
        PCSrc = 3'b000;
        Branch = 1;
        ConBA = 32'h00001000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00001000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        PCWrite = 1;
        PCSrc = 3'b001;
        ConBA = 32'h00002000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00002000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        PCWrite = 1;
        PCSrc = 3'b010;
        DataBusA = 32'hABCDE000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hABCDE000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        PC_In = 32'hF0000000;
        PCSrc = 3'b100;
        PCWrite = 1;
        @(posedge clk);
        #1;

        PCSrc = 3'b011;
        JT = 26'h03FFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hF0FFFFFC);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        PCWrite = 1;
        PCSrc = 3'b100;
        PC_In = 32'h12345678;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();

        PCWrite = 1;
        PCSrc = 3'b100;
        PC_In = 32'h5555AAAA;
        @(posedge clk);
        #1;

        PCWrite = 0;
        PCSrc = 3'b000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h5555AAAA);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();

        PCWrite = 1;
        PCSrc = 3'b100;
        PC_In = 32'hFFFFFFFF;
        @(posedge clk);
        #1;

        flush = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h80000000);
        flush = 0;
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_dut();

        PCWrite = 1;
        PCSrc = 3'b100;
        PC_In = 32'h7FFFFFFF;
        @(posedge clk);
        #1;

        flush = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
        flush = 0;
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_PC_Out;
        begin
            if (expected_PC_Out === (expected_PC_Out ^ PC_Out ^ expected_PC_Out)) begin
                $display("PASS");
                $display("  Outputs: PC_Out=%h",
                         PC_Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC_Out=%h",
                         expected_PC_Out);
                $display("  Got:      PC_Out=%h",
                         PC_Out);
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
        $dumpvars(0,Branch, ConBA, DataBusA, JT, PCSrc, PCWrite, PC_In, clk, flush, rst, PC_Out);
    end

endmodule
