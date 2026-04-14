`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALU_result_in;
    reg [4:0] Dest_in;
    reg MEM_R_EN_in;
    reg [31:0] Mem_read_value_in;
    reg [31:0] PC_in;
    reg WB_en_in;
    reg clk;
    reg rst;
    wire [31:0] ALU_result;
    wire [4:0] Dest;
    wire MEM_R_EN;
    wire [31:0] Mem_read_value;
    wire [31:0] PC;
    wire WB_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_result_in(ALU_result_in),
        .Dest_in(Dest_in),
        .MEM_R_EN_in(MEM_R_EN_in),
        .Mem_read_value_in(Mem_read_value_in),
        .PC_in(PC_in),
        .WB_en_in(WB_en_in),
        .clk(clk),
        .rst(rst),
        .ALU_result(ALU_result),
        .Dest(Dest),
        .MEM_R_EN(MEM_R_EN),
        .Mem_read_value(Mem_read_value),
        .PC(PC),
        .WB_en(WB_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        ALU_result_in = 32'h0;
        Dest_in = 5'h0;
        MEM_R_EN_in = 0;
        Mem_read_value_in = 32'h0;
        PC_in = 32'h0;
        WB_en_in = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Verify Reset State", test_num);
        reset_dut();


        #1;



        check_outputs(32'h0, 5'h0, 0, 32'h0, 32'h0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Latching standard instruction data", test_num);
        reset_dut();


        PC_in = 32'h0000_1000;
        WB_en_in = 1;
        MEM_R_EN_in = 0;
        ALU_result_in = 32'hAAAA_BBBB;
        Mem_read_value_in = 32'h1234_5678;
        Dest_in = 5'd15;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hAAAA_BBBB, 5'd15, 0, 32'h1234_5678, 32'h0000_1000, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Latching maximum value boundaries", test_num);
        reset_dut();

        PC_in = 32'hFFFF_FFFF;
        WB_en_in = 1;
        MEM_R_EN_in = 1;
        ALU_result_in = 32'hFFFF_FFFF;
        Mem_read_value_in = 32'hFFFF_FFFF;
        Dest_in = 5'h1F;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFF_FFFF, 5'h1F, 1, 32'hFFFF_FFFF, 32'hFFFF_FFFF, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Verification of Data Update", test_num);
        reset_dut();


        PC_in = 32'h0000_00A0;
        WB_en_in = 1;
        MEM_R_EN_in = 0;
        ALU_result_in = 32'h0000_0001;
        Mem_read_value_in = 32'h0000_0000;
        Dest_in = 5'd1;
        @(posedge clk);


        PC_in = 32'h0000_00B0;
        ALU_result_in = 32'h0000_0002;
        Dest_in = 5'd2;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0000_0002, 5'd2, 0, 32'h0000_0000, 32'h0000_00B0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Reset Priority over Inputs", test_num);
        reset_dut();


        PC_in = 32'h1122_3344;
        ALU_result_in = 32'h5566_7788;
        rst = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h0, 5'h0, 0, 32'h0, 32'h0, 0);
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
        input [31:0] expected_ALU_result;
        input [4:0] expected_Dest;
        input expected_MEM_R_EN;
        input [31:0] expected_Mem_read_value;
        input [31:0] expected_PC;
        input expected_WB_en;
        begin
            if (expected_ALU_result === (expected_ALU_result ^ ALU_result ^ expected_ALU_result) &&
                expected_Dest === (expected_Dest ^ Dest ^ expected_Dest) &&
                expected_MEM_R_EN === (expected_MEM_R_EN ^ MEM_R_EN ^ expected_MEM_R_EN) &&
                expected_Mem_read_value === (expected_Mem_read_value ^ Mem_read_value ^ expected_Mem_read_value) &&
                expected_PC === (expected_PC ^ PC ^ expected_PC) &&
                expected_WB_en === (expected_WB_en ^ WB_en ^ expected_WB_en)) begin
                $display("PASS");
                $display("  Outputs: ALU_result=%h, Dest=%h, MEM_R_EN=%b, Mem_read_value=%h, PC=%h, WB_en=%b",
                         ALU_result, Dest, MEM_R_EN, Mem_read_value, PC, WB_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_result=%h, Dest=%h, MEM_R_EN=%b, Mem_read_value=%h, PC=%h, WB_en=%b",
                         expected_ALU_result, expected_Dest, expected_MEM_R_EN, expected_Mem_read_value, expected_PC, expected_WB_en);
                $display("  Got:      ALU_result=%h, Dest=%h, MEM_R_EN=%b, Mem_read_value=%h, PC=%h, WB_en=%b",
                         ALU_result, Dest, MEM_R_EN, Mem_read_value, PC, WB_en);
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
        $dumpvars(0,ALU_result_in, Dest_in, MEM_R_EN_in, Mem_read_value_in, PC_in, WB_en_in, clk, rst, ALU_result, Dest, MEM_R_EN, Mem_read_value, PC, WB_en);
    end

endmodule
