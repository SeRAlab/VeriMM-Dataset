`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] M;
    reg [4:0] Regd;
    reg [1:0] WB;
    reg clk;
    reg [31:0] read_2;
    reg [31:0] result;
    wire [2:0] M_o;
    wire [31:0] Read_2;
    wire [4:0] RegD;
    wire [31:0] Result;
    wire [1:0] WB_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M(M),
        .Regd(Regd),
        .WB(WB),
        .clk(clk),
        .read_2(read_2),
        .result(result),
        .M_o(M_o),
        .Read_2(Read_2),
        .RegD(RegD),
        .Result(Result),
        .WB_o(WB_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            WB = 0;
            M = 0;
            result = 0;
            read_2 = 0;
            Regd = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running testcase001: Basic functional latching");
            WB = 2'b11;
            M = 3'b101;
            result = 32'hAAAA_BBBB;
            read_2 = 32'h1234_5678;
            Regd = 5'd15;

            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b101, 32'h1234_5678, 5'd15, 32'hAAAA_BBBB, 2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running testcase002: Maximum value latching (all ones)");
            WB = 2'b11;
            M = 3'b111;
            result = 32'hFFFF_FFFF;
            read_2 = 32'hFFFF_FFFF;
            Regd = 5'b11111;

            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b111, 32'hFFFF_FFFF, 5'b11111, 32'hFFFF_FFFF, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running testcase003: Minimum value latching (all zeros)");
            WB = 2'b00;
            M = 3'b000;
            result = 32'h0000_0000;
            read_2 = 32'h0000_0000;
            Regd = 5'b00000;

            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b000, 32'h0000_0000, 5'b00000, 32'h0000_0000, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running testcase004: Alternating bit patterns");
            WB = 2'b10;
            M = 3'b010;
            result = 32'h5555_AAAA;
            read_2 = 32'hAAAA_5555;
            Regd = 5'b10101;

            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b010, 32'hAAAA_5555, 5'b10101, 32'h5555_AAAA, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Running testcase005: Transition check");


            WB = 2'b01;
            M = 3'b011;
            result = 32'hDEAD_BEEF;
            read_2 = 32'hCAFE_BABE;
            Regd = 5'd31;

            @(posedge clk);
            #2;


            WB = 2'b00;
            M = 3'b000;
            result = 32'h0;
            read_2 = 32'h0;
            Regd = 5'd0;

            #1;
            #1;

            check_outputs(3'b011, 32'hCAFE_BABE, 5'd31, 32'hDEAD_BEEF, 2'b01);
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
        input [2:0] expected_M_o;
        input [31:0] expected_Read_2;
        input [4:0] expected_RegD;
        input [31:0] expected_Result;
        input [1:0] expected_WB_o;
        begin
            if (expected_M_o === (expected_M_o ^ M_o ^ expected_M_o) &&
                expected_Read_2 === (expected_Read_2 ^ Read_2 ^ expected_Read_2) &&
                expected_RegD === (expected_RegD ^ RegD ^ expected_RegD) &&
                expected_Result === (expected_Result ^ Result ^ expected_Result) &&
                expected_WB_o === (expected_WB_o ^ WB_o ^ expected_WB_o)) begin
                $display("PASS");
                $display("  Outputs: M_o=%h, Read_2=%h, RegD=%h, Result=%h, WB_o=%h",
                         M_o, Read_2, RegD, Result, WB_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M_o=%h, Read_2=%h, RegD=%h, Result=%h, WB_o=%h",
                         expected_M_o, expected_Read_2, expected_RegD, expected_Result, expected_WB_o);
                $display("  Got:      M_o=%h, Read_2=%h, RegD=%h, Result=%h, WB_o=%h",
                         M_o, Read_2, RegD, Result, WB_o);
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
        $dumpvars(0,M, Regd, WB, clk, read_2, result, M_o, Read_2, RegD, Result, WB_o);
    end

endmodule
