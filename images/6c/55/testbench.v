`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] RsAddr;
    reg [4:0] RtAddr;
    reg clk;
    reg double;
    reg jal;
    reg [31:0] pc;
    reg [4:0] regWriteAddr;
    reg [63:0] regWriteData;
    reg regWriteEn;
    reg reset;
    reg [4:0] switch;
    wire [31:0] RsData;
    wire [31:0] RtData;
    wire [15:0] regtoshow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RsAddr(RsAddr),
        .RtAddr(RtAddr),
        .clk(clk),
        .double(double),
        .jal(jal),
        .pc(pc),
        .regWriteAddr(regWriteAddr),
        .regWriteData(regWriteData),
        .regWriteEn(regWriteEn),
        .reset(reset),
        .switch(switch),
        .RsData(RsData),
        .RtData(RtData),
        .regtoshow(regtoshow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            double = 0;
            jal = 0;
            regWriteEn = 0;
            RsAddr = 0;
            RtAddr = 0;
            regWriteAddr = 0;
            regWriteData = 0;
            pc = 0;
            switch = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();

            RsAddr = 5;
            RtAddr = 10;
            switch = 15;
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 16'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Register Write", test_num);
            reset_dut();


            regWriteEn = 1;
            regWriteAddr = 5;
            regWriteData = 64'h0000000012345678;
            @(posedge clk);
            #1 regWriteEn = 0;


            RsAddr = 5;
            RtAddr = 0;
            switch = 5;
            #2;
            #1;

            check_outputs(32'h12345678, 32'h0, 16'h5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: JAL to Register 31", test_num);
            reset_dut();


            jal = 1;
            regWriteEn = 1;
            pc = 32'hABCDE000;
            @(posedge clk);
            #1 jal = 0; regWriteEn = 0;

            RtAddr = 31;
            switch = 31;
            #2;
            #1;

            check_outputs(32'h0, 32'hABCDE000, 16'hE000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Switch Input for regtoshow", test_num);
            reset_dut();


            regWriteEn = 1;
            regWriteAddr = 20;
            regWriteData = 64'hFFFFFFFFABCD1234;
            @(posedge clk);
            #1 regWriteEn = 0;

            switch = 20;
            RsAddr = 20;
            #2;
            #1;

            check_outputs(32'hABCD1234, 32'h0, 16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Double 64-bit Write", test_num);
            reset_dut();

            double = 1;
            regWriteEn = 1;
            regWriteAddr = 2;
            regWriteData = 64'hAAAA_BBBB_CCCC_DDDD;
            @(posedge clk);
            #1 double = 0; regWriteEn = 0;

            RsAddr = 2;
            switch = 2;
            #2;

            #1;


            check_outputs(32'hCCCC_DDDD, 32'h0, 16'hDDDD);
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
        input [31:0] expected_RsData;
        input [31:0] expected_RtData;
        input [15:0] expected_regtoshow;
        begin
            if (expected_RsData === (expected_RsData ^ RsData ^ expected_RsData) &&
                expected_RtData === (expected_RtData ^ RtData ^ expected_RtData) &&
                expected_regtoshow === (expected_regtoshow ^ regtoshow ^ expected_regtoshow)) begin
                $display("PASS");
                $display("  Outputs: RsData=%h, RtData=%h, regtoshow=%h",
                         RsData, RtData, regtoshow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RsData=%h, RtData=%h, regtoshow=%h",
                         expected_RsData, expected_RtData, expected_regtoshow);
                $display("  Got:      RsData=%h, RtData=%h, regtoshow=%h",
                         RsData, RtData, regtoshow);
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
        $dumpvars(0,RsAddr, RtAddr, clk, double, jal, pc, regWriteAddr, regWriteData, regWriteEn, reset, switch, RsData, RtData, regtoshow);
    end

endmodule
