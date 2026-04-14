`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RReady;
    reg RST;
    reg [15:0] Receive;
    reg WDone;
    wire [9:0] RCnt;
    wire REnable;
    wire [15:0] RcvOut;
    wire [15:0] Send;
    wire [9:0] WCnt;
    wire WEnable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RReady(RReady),
        .RST(RST),
        .Receive(Receive),
        .WDone(WDone),
        .RCnt(RCnt),
        .REnable(REnable),
        .RcvOut(RcvOut),
        .Send(Send),
        .WCnt(WCnt),
        .WEnable(WEnable)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        WDone = 0;
        RReady = 0;
        Receive = 0;

        repeat(2) @(posedge CLK);
        #1 RST = 0;
        repeat(2) @(posedge CLK);
    end
        endtask
    task testcase001;

    begin
        $display("\nTestcase 001: Initial Reset State");
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(10'd0, 1'b0, 16'h0, 16'h0, 10'd0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Single Write Operation");
        test_num = 2;
        reset_dut();



        WDone = 1;
        @(posedge CLK);
        WDone = 0;
        repeat(2) @(posedge CLK);



        #1;




        check_outputs(10'd0, 1'b0, 16'h0, 16'h0, 10'd1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: Single Read Operation");
        test_num = 3;
        reset_dut();


        Receive = 16'hABCD;
        RReady = 1;
        @(posedge CLK);
        RReady = 0;
        repeat(2) @(posedge CLK);


        #1;



        check_outputs(10'd1, 1'b0, 16'hABCD, 16'h0, 10'd0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: Multiple Write Operations");
        test_num = 4;
        reset_dut();


        WDone = 1;
        @(posedge CLK);
        WDone = 0;
        repeat(2) @(posedge CLK);


        WDone = 1;
        @(posedge CLK);
        WDone = 0;
        repeat(2) @(posedge CLK);


        #1;



        check_outputs(10'd0, 1'b0, 16'h0, 16'h0, 10'd2, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Multiple Read Operations");
        test_num = 5;
        reset_dut();


        Receive = 16'h1111;
        RReady = 1;
        @(posedge CLK);
        RReady = 0;
        repeat(2) @(posedge CLK);


        Receive = 16'h2222;
        RReady = 1;
        @(posedge CLK);
        RReady = 0;
        repeat(2) @(posedge CLK);


        #1;



        check_outputs(10'd2, 1'b0, 16'h2222, 16'h0, 10'd0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("\nTestcase 006: Interleaved Write and Read");
        test_num = 6;
        reset_dut();


        WDone = 1;
        @(posedge CLK);
        WDone = 0;
        repeat(2) @(posedge CLK);


        Receive = 16'hCAFE;
        RReady = 1;
        @(posedge CLK);
        RReady = 0;
        repeat(2) @(posedge CLK);


        #1;



        check_outputs(10'd1, 1'b0, 16'hCAFE, 16'h0, 10'd1, 1'b0);
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
        input [9:0] expected_RCnt;
        input expected_REnable;
        input [15:0] expected_RcvOut;
        input [15:0] expected_Send;
        input [9:0] expected_WCnt;
        input expected_WEnable;
        begin
            if (expected_RCnt === (expected_RCnt ^ RCnt ^ expected_RCnt) &&
                expected_REnable === (expected_REnable ^ REnable ^ expected_REnable) &&
                expected_RcvOut === (expected_RcvOut ^ RcvOut ^ expected_RcvOut) &&
                expected_Send === (expected_Send ^ Send ^ expected_Send) &&
                expected_WCnt === (expected_WCnt ^ WCnt ^ expected_WCnt) &&
                expected_WEnable === (expected_WEnable ^ WEnable ^ expected_WEnable)) begin
                $display("PASS");
                $display("  Outputs: RCnt=%h, REnable=%b, RcvOut=%h, Send=%h, WCnt=%h, WEnable=%b",
                         RCnt, REnable, RcvOut, Send, WCnt, WEnable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RCnt=%h, REnable=%b, RcvOut=%h, Send=%h, WCnt=%h, WEnable=%b",
                         expected_RCnt, expected_REnable, expected_RcvOut, expected_Send, expected_WCnt, expected_WEnable);
                $display("  Got:      RCnt=%h, REnable=%b, RcvOut=%h, Send=%h, WCnt=%h, WEnable=%b",
                         RCnt, REnable, RcvOut, Send, WCnt, WEnable);
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
        $dumpvars(0,CLK, RReady, RST, Receive, WDone, RCnt, REnable, RcvOut, Send, WCnt, WEnable);
    end

endmodule
