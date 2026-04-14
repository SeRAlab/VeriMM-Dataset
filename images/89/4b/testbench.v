`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg I_Cin;
    reg [3:0] I_aluop;
    reg I_clk;
    reg [31:0] I_dataA;
    reg [31:0] I_dataB;
    reg I_rst;
    wire O_Cout;
    wire [31:0] O_adderResult;
    wire O_dataReady;
    wire [31:0] O_dataResult;
    wire O_multiCycle;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_Cin(I_Cin),
        .I_aluop(I_aluop),
        .I_clk(I_clk),
        .I_dataA(I_dataA),
        .I_dataB(I_dataB),
        .I_rst(I_rst),
        .O_Cout(O_Cout),
        .O_adderResult(O_adderResult),
        .O_dataReady(O_dataReady),
        .O_dataResult(O_dataResult),
        .O_multiCycle(O_multiCycle)
    );

    // Clock generation (10ns period)
    initial begin
        I_clk = 0;
        forever #5 I_clk = ~I_clk;
    end

        task reset_dut;

    begin
        I_rst = 1;
        I_Cin = 0;
        I_aluop = 0;
        I_dataA = 0;
        I_dataB = 0;
        @(posedge I_clk);
        #2 I_rst = 0;
        @(posedge I_clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %03d: Addition (10 + 20)", test_num);
        I_dataA = 32'd10;
        I_dataB = 32'd20;
        I_Cin = 0;
        I_aluop = 4'b0000;
        @(posedge I_clk);
        #2;

        #1;


        check_outputs(1'b0, 32'd30, 1'b1, 32'd30, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %03d: Addition with Carry In (5 + 5 + 1)", test_num);
        I_dataA = 32'd5;
        I_dataB = 32'd5;
        I_Cin = 1;
        I_aluop = 4'b0000;
        @(posedge I_clk);
        #2;

        #1;


        check_outputs(1'b0, 32'd11, 1'b1, 32'd11, 1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %03d: Subtraction (50 - 20)", test_num);
        I_dataA = 32'd50;
        I_dataB = 32'd20;
        I_aluop = 4'b0001;
        @(posedge I_clk);
        #2;



        #1;




        check_outputs(1'b0, 32'd70, 1'b1, 32'd30, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %03d: Bitwise AND (0xF0F0 & 0x0F0F)", test_num);
        I_dataA = 32'hF0F0F0F0;
        I_dataB = 32'h0F0F0F0F;
        I_aluop = 4'b0010;
        @(posedge I_clk);
        #2;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF, 1'b1, 32'h00000000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %03d: Bitwise OR (0xA5A5 | 0x5A5A)", test_num);
        I_dataA = 32'hA5A5A5A5;
        I_dataB = 32'h5A5A5A5A;
        I_aluop = 4'b0011;
        @(posedge I_clk);
        #2;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF, 1'b1, 32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %03d: Addition Overflow Carry", test_num);
        I_dataA = 32'hFFFFFFFF;
        I_dataB = 32'h00000001;
        I_Cin = 0;
        I_aluop = 4'b0000;
        @(posedge I_clk);
        #2;
        #1;

        check_outputs(1'b1, 32'h00000000, 1'b1, 32'h00000000, 1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %03d: Bitwise XOR", test_num);
        I_dataA = 32'h12345678;
        I_dataB = 32'h12345678;
        I_aluop = 4'b0100;
        @(posedge I_clk);
        #2;
        #1;

        check_outputs(1'b0, 32'h2468ACF0, 1'b1, 32'h00000000, 1'b0);
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
        input expected_O_Cout;
        input [31:0] expected_O_adderResult;
        input expected_O_dataReady;
        input [31:0] expected_O_dataResult;
        input expected_O_multiCycle;
        begin
            if (expected_O_Cout === (expected_O_Cout ^ O_Cout ^ expected_O_Cout) &&
                expected_O_adderResult === (expected_O_adderResult ^ O_adderResult ^ expected_O_adderResult) &&
                expected_O_dataReady === (expected_O_dataReady ^ O_dataReady ^ expected_O_dataReady) &&
                expected_O_dataResult === (expected_O_dataResult ^ O_dataResult ^ expected_O_dataResult) &&
                expected_O_multiCycle === (expected_O_multiCycle ^ O_multiCycle ^ expected_O_multiCycle)) begin
                $display("PASS");
                $display("  Outputs: O_Cout=%b, O_adderResult=%h, O_dataReady=%b, O_dataResult=%h, O_multiCycle=%b",
                         O_Cout, O_adderResult, O_dataReady, O_dataResult, O_multiCycle);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O_Cout=%b, O_adderResult=%h, O_dataReady=%b, O_dataResult=%h, O_multiCycle=%b",
                         expected_O_Cout, expected_O_adderResult, expected_O_dataReady, expected_O_dataResult, expected_O_multiCycle);
                $display("  Got:      O_Cout=%b, O_adderResult=%h, O_dataReady=%b, O_dataResult=%h, O_multiCycle=%b",
                         O_Cout, O_adderResult, O_dataReady, O_dataResult, O_multiCycle);
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
        $dumpvars(0,I_Cin, I_aluop, I_clk, I_dataA, I_dataB, I_rst, O_Cout, O_adderResult, O_dataReady, O_dataResult, O_multiCycle);
    end

endmodule
