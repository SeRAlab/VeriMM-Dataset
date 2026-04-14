`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] Regd;
    reg [1:0] WB_2;
    reg [31:0] aluresult;
    reg clk;
    reg [31:0] dm_read;
    wire [31:0] Aluresult;
    wire [31:0] DmRead;
    wire [4:0] RegD;
    wire [1:0] WB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Regd(Regd),
        .WB_2(WB_2),
        .aluresult(aluresult),
        .clk(clk),
        .dm_read(dm_read),
        .Aluresult(Aluresult),
        .DmRead(DmRead),
        .RegD(RegD),
        .WB(WB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        Regd = 0;
        WB_2 = 0;
        aluresult = 0;
        dm_read = 0;


        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Data Transfer", test_num);
        reset_dut();


        WB_2 = 2'b10;
        dm_read = 32'hA5A5A5A5;
        aluresult = 32'h12345678;
        Regd = 5'd10;


        @(posedge clk);
        #2;


        #1;



        check_outputs(32'h12345678, 32'hA5A5A5A5, 5'd10, 2'b10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Ones", test_num);
        reset_dut();

        WB_2 = 2'b11;
        dm_read = 32'hFFFFFFFF;
        aluresult = 32'hFFFFFFFF;
        Regd = 5'h1F;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 5'h1F, 2'b11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits", test_num);
        reset_dut();

        WB_2 = 2'b01;
        dm_read = 32'h55555555;
        aluresult = 32'hAAAAAAAA;
        Regd = 5'd31;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hAAAAAAAA, 32'h55555555, 5'd31, 2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Values", test_num);
        reset_dut();

        WB_2 = 2'b00;
        dm_read = 32'h00000000;
        aluresult = 32'h00000000;
        Regd = 5'd0;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h00000000, 32'h00000000, 5'd0, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Value Test", test_num);
        reset_dut();

        WB_2 = 2'b10;
        dm_read = 32'hDEADC0DE;
        aluresult = 32'hBEEFCAFE;
        Regd = 5'd1;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hBEEFCAFE, 32'hDEADC0DE, 5'd1, 2'b10);
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
        input [31:0] expected_Aluresult;
        input [31:0] expected_DmRead;
        input [4:0] expected_RegD;
        input [1:0] expected_WB;
        begin
            if (expected_Aluresult === (expected_Aluresult ^ Aluresult ^ expected_Aluresult) &&
                expected_DmRead === (expected_DmRead ^ DmRead ^ expected_DmRead) &&
                expected_RegD === (expected_RegD ^ RegD ^ expected_RegD) &&
                expected_WB === (expected_WB ^ WB ^ expected_WB)) begin
                $display("PASS");
                $display("  Outputs: Aluresult=%h, DmRead=%h, RegD=%h, WB=%h",
                         Aluresult, DmRead, RegD, WB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Aluresult=%h, DmRead=%h, RegD=%h, WB=%h",
                         expected_Aluresult, expected_DmRead, expected_RegD, expected_WB);
                $display("  Got:      Aluresult=%h, DmRead=%h, RegD=%h, WB=%h",
                         Aluresult, DmRead, RegD, WB);
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
        $dumpvars(0,Regd, WB_2, aluresult, clk, dm_read, Aluresult, DmRead, RegD, WB);
    end

endmodule
