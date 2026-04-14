`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALU_result_in;
    reg [4:0] Dest_in;
    reg MEM_R_EN_in;
    reg MEM_W_EN_in;
    reg [31:0] ST_val_in;
    reg WB_en_in;
    reg clk;
    reg freeze;
    reg rst;
    wire [31:0] ALU_result;
    wire [4:0] Dest;
    wire MEM_R_EN;
    wire MEM_W_EN;
    wire [31:0] ST_Val;
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
        .MEM_W_EN_in(MEM_W_EN_in),
        .ST_val_in(ST_val_in),
        .WB_en_in(WB_en_in),
        .clk(clk),
        .freeze(freeze),
        .rst(rst),
        .ALU_result(ALU_result),
        .Dest(Dest),
        .MEM_R_EN(MEM_R_EN),
        .MEM_W_EN(MEM_W_EN),
        .ST_Val(ST_Val),
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
        freeze = 0;
        WB_en_in = 0;
        MEM_R_EN_in = 0;
        MEM_W_EN_in = 0;
        ALU_result_in = 32'h0;
        ST_val_in = 32'h0;
        Dest_in = 5'h0;
        @(posedge clk);
        #2;
        rst = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Reset Functionality", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 5'h0, 1'b0, 1'b0, 32'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Normal Data Loading", test_num);
        reset_dut();


        WB_en_in = 1;
        MEM_R_EN_in = 1;
        MEM_W_EN_in = 0;
        ALU_result_in = 32'hDEADBEEF;
        ST_val_in = 32'h12345678;
        Dest_in = 5'h1F;
        freeze = 0;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hDEADBEEF, 5'h1F, 1'b1, 1'b0, 32'h12345678, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Freeze Functionality", test_num);
        reset_dut();


        WB_en_in = 1;
        ALU_result_in = 32'hAAAA_AAAA;
        Dest_in = 5'h0A;
        @(posedge clk);
        #2;


        freeze = 1;
        WB_en_in = 0;
        ALU_result_in = 32'hBBBB_BBBB;
        Dest_in = 5'h1B;
        @(posedge clk);
        #2;


        #1;



        check_outputs(32'hAAAA_AAAA, 5'h0A, 1'b0, 1'b0, 32'h0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Reset Priority over Freeze", test_num);
        reset_dut();


        WB_en_in = 1;
        ALU_result_in = 32'h1111_2222;
        @(posedge clk);
        #2;


        freeze = 1;
        rst = 1;
        @(posedge clk);
        #2;


        #1;



        check_outputs(32'h0, 5'h0, 1'b0, 1'b0, 32'h0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Recovery from Freeze", test_num);
        reset_dut();


        freeze = 1;
        ALU_result_in = 32'hFFFF_FFFF;
        @(posedge clk);
        #2;


        freeze = 0;
        ALU_result_in = 32'hCCCC_DDDD;
        Dest_in = 5'h05;
        @(posedge clk);
        #2;


        #1;



        check_outputs(32'hCCCC_DDDD, 5'h05, 1'b0, 1'b0, 32'h0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Memory Control Signal Toggle", test_num);
        reset_dut();

        WB_en_in = 0;
        MEM_R_EN_in = 0;
        MEM_W_EN_in = 1;
        ALU_result_in = 32'hCAFE_BABE;
        ST_val_in = 32'h8765_4321;
        Dest_in = 5'h10;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hCAFE_BABE, 5'h10, 1'b0, 1'b1, 32'h8765_4321, 1'b0);
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
        input [31:0] expected_ALU_result;
        input [4:0] expected_Dest;
        input expected_MEM_R_EN;
        input expected_MEM_W_EN;
        input [31:0] expected_ST_Val;
        input expected_WB_en;
        begin
            if (expected_ALU_result === (expected_ALU_result ^ ALU_result ^ expected_ALU_result) &&
                expected_Dest === (expected_Dest ^ Dest ^ expected_Dest) &&
                expected_MEM_R_EN === (expected_MEM_R_EN ^ MEM_R_EN ^ expected_MEM_R_EN) &&
                expected_MEM_W_EN === (expected_MEM_W_EN ^ MEM_W_EN ^ expected_MEM_W_EN) &&
                expected_ST_Val === (expected_ST_Val ^ ST_Val ^ expected_ST_Val) &&
                expected_WB_en === (expected_WB_en ^ WB_en ^ expected_WB_en)) begin
                $display("PASS");
                $display("  Outputs: ALU_result=%h, Dest=%h, MEM_R_EN=%b, MEM_W_EN=%b, ST_Val=%h, WB_en=%b",
                         ALU_result, Dest, MEM_R_EN, MEM_W_EN, ST_Val, WB_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_result=%h, Dest=%h, MEM_R_EN=%b, MEM_W_EN=%b, ST_Val=%h, WB_en=%b",
                         expected_ALU_result, expected_Dest, expected_MEM_R_EN, expected_MEM_W_EN, expected_ST_Val, expected_WB_en);
                $display("  Got:      ALU_result=%h, Dest=%h, MEM_R_EN=%b, MEM_W_EN=%b, ST_Val=%h, WB_en=%b",
                         ALU_result, Dest, MEM_R_EN, MEM_W_EN, ST_Val, WB_en);
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
        $dumpvars(0,ALU_result_in, Dest_in, MEM_R_EN_in, MEM_W_EN_in, ST_val_in, WB_en_in, clk, freeze, rst, ALU_result, Dest, MEM_R_EN, MEM_W_EN, ST_Val, WB_en);
    end

endmodule
