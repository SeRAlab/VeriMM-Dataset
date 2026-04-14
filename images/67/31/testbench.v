`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] ALU_Result;
    reg [63:0] Adder_Result;
    reg [63:0] Forward_B_Mux_Result;
    reg [2:0] M;
    reg [1:0] WB;
    reg clk;
    reg comp;
    reg flush;
    reg [4:0] rd;
    wire [63:0] ALU_Result_Out;
    wire [63:0] Adder_Result_Out;
    wire Branch;
    wire [63:0] Forward_B_Mux_Result_Out;
    wire MemRead;
    wire MemWrite;
    wire [1:0] WB_Out;
    wire comp_Out;
    wire [4:0] rd_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_Result(ALU_Result),
        .Adder_Result(Adder_Result),
        .Forward_B_Mux_Result(Forward_B_Mux_Result),
        .M(M),
        .WB(WB),
        .clk(clk),
        .comp(comp),
        .flush(flush),
        .rd(rd),
        .ALU_Result_Out(ALU_Result_Out),
        .Adder_Result_Out(Adder_Result_Out),
        .Branch(Branch),
        .Forward_B_Mux_Result_Out(Forward_B_Mux_Result_Out),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .WB_Out(WB_Out),
        .comp_Out(comp_Out),
        .rd_out(rd_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            flush = 1;
            ALU_Result = 0;
            Adder_Result = 0;
            Forward_B_Mux_Result = 0;
            M = 0;
            WB = 0;
            comp = 0;
            rd = 0;
            @(posedge clk);
            #1;
            flush = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Data Propagation", test_num);
            reset_dut();


            WB = 2'b11;
            M = 3'b101;
            Adder_Result = 64'hAAAA_BBBB_CCCC_DDDD;
            comp = 1;
            ALU_Result = 64'h1234_5678_9ABC_DEF0;
            Forward_B_Mux_Result = 64'hFEDC_BA98_7654_3210;
            rd = 5'd15;
            flush = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(64'h1234_5678_9ABC_DEF0, 64'hAAAA_BBBB_CCCC_DDDD, 1'b1, 64'hFEDC_BA98_7654_3210, 1'b1, 1'b0, 2'b11, 1'b1, 5'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Flush Operation", test_num);
            reset_dut();


            WB = 2'b01;
            M = 3'b010;
            Adder_Result = 64'hFFFF_FFFF_FFFF_FFFF;
            comp = 0;
            ALU_Result = 64'h8888_7777_6666_5555;
            Forward_B_Mux_Result = 64'h1111_2222_3333_4444;
            rd = 5'd31;
            flush = 1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(64'h0, 64'h0, 1'b0, 64'h0, 1'b0, 1'b0, 2'b0, 1'b0, 5'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dynamic Operation", test_num);
            reset_dut();


            WB = 2'b10;
            M = 3'b111;
            Adder_Result = 64'h1;
            comp = 1;
            ALU_Result = 64'h2;
            Forward_B_Mux_Result = 64'h3;
            rd = 5'd10;
            flush = 0;
            @(posedge clk);
            #1;


            WB = 2'b01;
            M = 3'b000;
            Adder_Result = 64'hA;
            comp = 0;
            ALU_Result = 64'hB;
            Forward_B_Mux_Result = 64'hC;
            rd = 5'd20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hB, 64'hA, 1'b0, 64'hC, 1'b0, 1'b0, 2'b01, 1'b0, 5'd20);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Memory Control Signal Mapping", test_num);
            reset_dut();


            M = 3'b101;
            flush = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ALU_Result, Adder_Result, 1'b1, Forward_B_Mux_Result, 1'b1, 1'b0, WB, comp, rd);


            M = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ALU_Result, Adder_Result, 1'b0, Forward_B_Mux_Result, 1'b0, 1'b1, WB, comp, rd);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values", test_num);
            reset_dut();

            WB = 2'b11;
            M = 3'b111;
            Adder_Result = 64'hFFFF_FFFF_FFFF_FFFF;
            comp = 1;
            ALU_Result = 64'hFFFF_FFFF_FFFF_FFFF;
            Forward_B_Mux_Result = 64'hFFFF_FFFF_FFFF_FFFF;
            rd = 5'b11111;
            flush = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 64'hFFFF_FFFF_FFFF_FFFF, 1'b1, 64'hFFFF_FFFF_FFFF_FFFF, 1'b1, 1'b1, 2'b11, 1'b1, 5'h1F);
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
        input [63:0] expected_ALU_Result_Out;
        input [63:0] expected_Adder_Result_Out;
        input expected_Branch;
        input [63:0] expected_Forward_B_Mux_Result_Out;
        input expected_MemRead;
        input expected_MemWrite;
        input [1:0] expected_WB_Out;
        input expected_comp_Out;
        input [4:0] expected_rd_out;
        begin
            if (expected_ALU_Result_Out === (expected_ALU_Result_Out ^ ALU_Result_Out ^ expected_ALU_Result_Out) &&
                expected_Adder_Result_Out === (expected_Adder_Result_Out ^ Adder_Result_Out ^ expected_Adder_Result_Out) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_Forward_B_Mux_Result_Out === (expected_Forward_B_Mux_Result_Out ^ Forward_B_Mux_Result_Out ^ expected_Forward_B_Mux_Result_Out) &&
                expected_MemRead === (expected_MemRead ^ MemRead ^ expected_MemRead) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_WB_Out === (expected_WB_Out ^ WB_Out ^ expected_WB_Out) &&
                expected_comp_Out === (expected_comp_Out ^ comp_Out ^ expected_comp_Out) &&
                expected_rd_out === (expected_rd_out ^ rd_out ^ expected_rd_out)) begin
                $display("PASS");
                $display("  Outputs: ALU_Result_Out=%h, Adder_Result_Out=%h, Branch=%b, Forward_B_Mux_Result_Out=%h, MemRead=%b, MemWrite=%b, WB_Out=%h, comp_Out=%b, rd_out=%h",
                         ALU_Result_Out, Adder_Result_Out, Branch, Forward_B_Mux_Result_Out, MemRead, MemWrite, WB_Out, comp_Out, rd_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_Result_Out=%h, Adder_Result_Out=%h, Branch=%b, Forward_B_Mux_Result_Out=%h, MemRead=%b, MemWrite=%b, WB_Out=%h, comp_Out=%b, rd_out=%h",
                         expected_ALU_Result_Out, expected_Adder_Result_Out, expected_Branch, expected_Forward_B_Mux_Result_Out, expected_MemRead, expected_MemWrite, expected_WB_Out, expected_comp_Out, expected_rd_out);
                $display("  Got:      ALU_Result_Out=%h, Adder_Result_Out=%h, Branch=%b, Forward_B_Mux_Result_Out=%h, MemRead=%b, MemWrite=%b, WB_Out=%h, comp_Out=%b, rd_out=%h",
                         ALU_Result_Out, Adder_Result_Out, Branch, Forward_B_Mux_Result_Out, MemRead, MemWrite, WB_Out, comp_Out, rd_out);
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
        $dumpvars(0,ALU_Result, Adder_Result, Forward_B_Mux_Result, M, WB, clk, comp, flush, rd, ALU_Result_Out, Adder_Result_Out, Branch, Forward_B_Mux_Result_Out, MemRead, MemWrite, WB_Out, comp_Out, rd_out);
    end

endmodule
