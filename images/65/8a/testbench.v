`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] id_Aluc;
    reg id_LW;
    reg id_WMEM;
    reg id_WREG;
    reg [31:0] id_a;
    reg [31:0] id_b;
    reg [31:0] id_d2;
    reg [31:0] id_instr;
    reg [31:0] id_pc;
    reg [4:0] id_td;
    reg rst;
    reg stall;
    wire [4:0] ex_Aluc;
    wire ex_LW;
    wire ex_WMEM;
    wire ex_WREG;
    wire [31:0] ex_a;
    wire [31:0] ex_b;
    wire [31:0] ex_d2;
    wire [31:0] ex_instr;
    wire [31:0] ex_pc;
    wire [4:0] ex_td;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .id_Aluc(id_Aluc),
        .id_LW(id_LW),
        .id_WMEM(id_WMEM),
        .id_WREG(id_WREG),
        .id_a(id_a),
        .id_b(id_b),
        .id_d2(id_d2),
        .id_instr(id_instr),
        .id_pc(id_pc),
        .id_td(id_td),
        .rst(rst),
        .stall(stall),
        .ex_Aluc(ex_Aluc),
        .ex_LW(ex_LW),
        .ex_WMEM(ex_WMEM),
        .ex_WREG(ex_WREG),
        .ex_a(ex_a),
        .ex_b(ex_b),
        .ex_d2(ex_d2),
        .ex_instr(ex_instr),
        .ex_pc(ex_pc),
        .ex_td(ex_td)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            stall = 0;
            id_Aluc = 0;
            id_LW = 0;
            id_WMEM = 0;
            id_WREG = 0;
            id_a = 0;
            id_b = 0;
            id_d2 = 0;
            id_instr = 0;
            id_pc = 0;
            id_td = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();


            #1;



            check_outputs(5'h0, 1'b0, 1'b0, 1'b0, 32'h0, 32'h0, 32'h0, 32'h0, 32'h0, 5'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Normal Propagation", test_num);
            reset_dut();

            id_Aluc  = 5'h0A;
            id_LW    = 1'b1;
            id_WMEM  = 1'b0;
            id_WREG  = 1'b1;
            id_a     = 32'hAAAA_AAAA;
            id_b     = 32'hBBBB_BBBB;
            id_d2    = 32'hD2D2_D2D2;
            id_instr = 32'h1234_5678;
            id_pc    = 32'h0040_0000;
            id_td    = 5'h1F;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h0A, 1'b1, 1'b0, 1'b1, 32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'hD2D2_D2D2, 32'h1234_5678, 32'h0040_0000, 5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Stall Functionality", test_num);
            reset_dut();


            id_a = 32'h1111_1111;
            id_instr = 32'hFFFF_0000;
            @(posedge clk);
            #2;


            stall = 1;
            id_a = 32'hEEEE_EEEE;
            id_instr = 32'h0000_FFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(5'h0, 1'b0, 1'b0, 1'b0, 32'h1111_1111, 32'h0, 32'h0, 32'hFFFF_0000, 32'h0, 5'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Stall Release", test_num);
            reset_dut();


            stall = 1;
            id_a = 32'hCAFE_BABE;
            @(posedge clk);
            #2;


            stall = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(5'h0, 1'b0, 1'b0, 1'b0, 32'hCAFE_BABE, 32'h0, 32'h0, 32'h0, 32'h0, 5'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Complex Control Path", test_num);
            reset_dut();

            id_Aluc  = 5'h15;
            id_LW    = 1'b0;
            id_WMEM  = 1'b1;
            id_WREG  = 1'b0;
            id_a     = 32'h0000_0001;
            id_b     = 32'h0000_0002;
            id_d2    = 32'h0000_0003;
            id_instr = 32'hADD_00_123;
            id_pc    = 32'hBFC0_0000;
            id_td    = 5'h08;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h15, 1'b0, 1'b1, 1'b0, 32'h0000_0001, 32'h0000_0002, 32'h0000_0003, 32'hADD_00_123, 32'hBFC0_0000, 5'h08);
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
        input [4:0] expected_ex_Aluc;
        input expected_ex_LW;
        input expected_ex_WMEM;
        input expected_ex_WREG;
        input [31:0] expected_ex_a;
        input [31:0] expected_ex_b;
        input [31:0] expected_ex_d2;
        input [31:0] expected_ex_instr;
        input [31:0] expected_ex_pc;
        input [4:0] expected_ex_td;
        begin
            if (expected_ex_Aluc === (expected_ex_Aluc ^ ex_Aluc ^ expected_ex_Aluc) &&
                expected_ex_LW === (expected_ex_LW ^ ex_LW ^ expected_ex_LW) &&
                expected_ex_WMEM === (expected_ex_WMEM ^ ex_WMEM ^ expected_ex_WMEM) &&
                expected_ex_WREG === (expected_ex_WREG ^ ex_WREG ^ expected_ex_WREG) &&
                expected_ex_a === (expected_ex_a ^ ex_a ^ expected_ex_a) &&
                expected_ex_b === (expected_ex_b ^ ex_b ^ expected_ex_b) &&
                expected_ex_d2 === (expected_ex_d2 ^ ex_d2 ^ expected_ex_d2) &&
                expected_ex_instr === (expected_ex_instr ^ ex_instr ^ expected_ex_instr) &&
                expected_ex_pc === (expected_ex_pc ^ ex_pc ^ expected_ex_pc) &&
                expected_ex_td === (expected_ex_td ^ ex_td ^ expected_ex_td)) begin
                $display("PASS");
                $display("  Outputs: ex_Aluc=%h, ex_LW=%b, ex_WMEM=%b, ex_WREG=%b, ex_a=%h, ex_b=%h, ex_d2=%h, ex_instr=%h, ex_pc=%h, ex_td=%h",
                         ex_Aluc, ex_LW, ex_WMEM, ex_WREG, ex_a, ex_b, ex_d2, ex_instr, ex_pc, ex_td);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ex_Aluc=%h, ex_LW=%b, ex_WMEM=%b, ex_WREG=%b, ex_a=%h, ex_b=%h, ex_d2=%h, ex_instr=%h, ex_pc=%h, ex_td=%h",
                         expected_ex_Aluc, expected_ex_LW, expected_ex_WMEM, expected_ex_WREG, expected_ex_a, expected_ex_b, expected_ex_d2, expected_ex_instr, expected_ex_pc, expected_ex_td);
                $display("  Got:      ex_Aluc=%h, ex_LW=%b, ex_WMEM=%b, ex_WREG=%b, ex_a=%h, ex_b=%h, ex_d2=%h, ex_instr=%h, ex_pc=%h, ex_td=%h",
                         ex_Aluc, ex_LW, ex_WMEM, ex_WREG, ex_a, ex_b, ex_d2, ex_instr, ex_pc, ex_td);
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
        $dumpvars(0,clk, id_Aluc, id_LW, id_WMEM, id_WREG, id_a, id_b, id_d2, id_instr, id_pc, id_td, rst, stall, ex_Aluc, ex_LW, ex_WMEM, ex_WREG, ex_a, ex_b, ex_d2, ex_instr, ex_pc, ex_td);
    end

endmodule
