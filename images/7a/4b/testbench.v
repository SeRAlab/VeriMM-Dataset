`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [4:0] ControlsIn;
    reg [15:0] DataIn;
    reg Flush;
    reg [15:0] JEQAddrIn;
    reg [15:0] MemAddrIn;
    reg [2:0] Reg1In;
    reg Reset;
    reg [15:0] ResultIn;
    reg ZeroIn;
    wire [4:0] ControlsOut;
    wire [15:0] DataOut;
    wire [15:0] JEQAddrOut;
    wire [15:0] MemAddrOut;
    wire [2:0] Reg1Out;
    wire [15:0] ResultOut;
    wire ZeroOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .ControlsIn(ControlsIn),
        .DataIn(DataIn),
        .Flush(Flush),
        .JEQAddrIn(JEQAddrIn),
        .MemAddrIn(MemAddrIn),
        .Reg1In(Reg1In),
        .Reset(Reset),
        .ResultIn(ResultIn),
        .ZeroIn(ZeroIn),
        .ControlsOut(ControlsOut),
        .DataOut(DataOut),
        .JEQAddrOut(JEQAddrOut),
        .MemAddrOut(MemAddrOut),
        .Reg1Out(Reg1Out),
        .ResultOut(ResultOut),
        .ZeroOut(ZeroOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Reset = 1;
        Flush = 0;
        ControlsIn = 0;
        DataIn = 0;
        JEQAddrIn = 0;
        MemAddrIn = 0;
        Reg1In = 0;
        ResultIn = 0;
        ZeroIn = 0;
        @(posedge Clk);
        #1;
        Reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Initial Reset check", test_num);
        reset_dut();

        #1;


        check_outputs(5'h00, 16'h0000, 16'h0000, 16'h0000, 3'b000, 16'h0000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Normal Data Load", test_num);
        reset_dut();

        ControlsIn = 5'h1A;
        ResultIn   = 16'hABCD;
        ZeroIn     = 1'b1;
        DataIn     = 16'h1234;
        MemAddrIn  = 16'h5678;
        JEQAddrIn  = 16'h9ABC;
        Reg1In     = 3'b101;
        Flush      = 0;

        @(posedge Clk);
        #1;
        #1;

        check_outputs(5'h1A, 16'h1234, 16'h9ABC, 16'h5678, 3'b101, 16'hABCD, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Flush signal check", test_num);
        reset_dut();


        ControlsIn = 5'h1F;
        ResultIn   = 16'hFFFF;
        @(posedge Clk);
        #1;


        Flush = 1;
        ControlsIn = 5'h0A;
        @(posedge Clk);
        #1;


        #1;



        check_outputs(5'h00, 16'h0000, 16'h0000, 16'h0000, 3'b000, 16'h0000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Consecutive data updates", test_num);
        reset_dut();


        ControlsIn = 5'h01; ResultIn = 16'h1111;
        @(posedge Clk);
        #1;


        ControlsIn = 5'h02; ResultIn = 16'h2222; DataIn = 16'h3333;
        @(posedge Clk);
        #1;

        #1;


        check_outputs(5'h02, 16'h3333, 16'h0000, 16'h0000, 3'b000, 16'h2222, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Priority", test_num);
        reset_dut();

        Reset = 1;
        ControlsIn = 5'h15; ResultIn = 16'hEEEE;
        @(posedge Clk);
        #1;


        #1;



        check_outputs(5'h00, 16'h0000, 16'h0000, 16'h0000, 3'b000, 16'h0000, 1'b0);
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
        input [4:0] expected_ControlsOut;
        input [15:0] expected_DataOut;
        input [15:0] expected_JEQAddrOut;
        input [15:0] expected_MemAddrOut;
        input [2:0] expected_Reg1Out;
        input [15:0] expected_ResultOut;
        input expected_ZeroOut;
        begin
            if (expected_ControlsOut === (expected_ControlsOut ^ ControlsOut ^ expected_ControlsOut) &&
                expected_DataOut === (expected_DataOut ^ DataOut ^ expected_DataOut) &&
                expected_JEQAddrOut === (expected_JEQAddrOut ^ JEQAddrOut ^ expected_JEQAddrOut) &&
                expected_MemAddrOut === (expected_MemAddrOut ^ MemAddrOut ^ expected_MemAddrOut) &&
                expected_Reg1Out === (expected_Reg1Out ^ Reg1Out ^ expected_Reg1Out) &&
                expected_ResultOut === (expected_ResultOut ^ ResultOut ^ expected_ResultOut) &&
                expected_ZeroOut === (expected_ZeroOut ^ ZeroOut ^ expected_ZeroOut)) begin
                $display("PASS");
                $display("  Outputs: ControlsOut=%h, DataOut=%h, JEQAddrOut=%h, MemAddrOut=%h, Reg1Out=%h, ResultOut=%h, ZeroOut=%b",
                         ControlsOut, DataOut, JEQAddrOut, MemAddrOut, Reg1Out, ResultOut, ZeroOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ControlsOut=%h, DataOut=%h, JEQAddrOut=%h, MemAddrOut=%h, Reg1Out=%h, ResultOut=%h, ZeroOut=%b",
                         expected_ControlsOut, expected_DataOut, expected_JEQAddrOut, expected_MemAddrOut, expected_Reg1Out, expected_ResultOut, expected_ZeroOut);
                $display("  Got:      ControlsOut=%h, DataOut=%h, JEQAddrOut=%h, MemAddrOut=%h, Reg1Out=%h, ResultOut=%h, ZeroOut=%b",
                         ControlsOut, DataOut, JEQAddrOut, MemAddrOut, Reg1Out, ResultOut, ZeroOut);
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
        $dumpvars(0,Clk, ControlsIn, DataIn, Flush, JEQAddrIn, MemAddrIn, Reg1In, Reset, ResultIn, ZeroIn, ControlsOut, DataOut, JEQAddrOut, MemAddrOut, Reg1Out, ResultOut, ZeroOut);
    end

endmodule
