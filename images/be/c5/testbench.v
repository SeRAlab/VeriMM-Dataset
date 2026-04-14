`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] alu_result_in;
    reg clk;
    reg m_MemWrite_in;
    reg [4:0] mux_RegDst_in;
    reg [5:0] opcode_in;
    reg [31:0] r_data2_in;
    reg reset;
    reg wb_MemtoReg_in;
    reg wb_RegWrite_in;
    wire [31:0] alu_result_out;
    wire m_MemWrite_out;
    wire [4:0] mux_RegDst_out;
    wire [5:0] opcode_out;
    wire [31:0] r_data2_out;
    wire wb_MemtoReg_out;
    wire wb_RegWrite_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_result_in(alu_result_in),
        .clk(clk),
        .m_MemWrite_in(m_MemWrite_in),
        .mux_RegDst_in(mux_RegDst_in),
        .opcode_in(opcode_in),
        .r_data2_in(r_data2_in),
        .reset(reset),
        .wb_MemtoReg_in(wb_MemtoReg_in),
        .wb_RegWrite_in(wb_RegWrite_in),
        .alu_result_out(alu_result_out),
        .m_MemWrite_out(m_MemWrite_out),
        .mux_RegDst_out(mux_RegDst_out),
        .opcode_out(opcode_out),
        .r_data2_out(r_data2_out),
        .wb_MemtoReg_out(wb_MemtoReg_out),
        .wb_RegWrite_out(wb_RegWrite_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        ena = 1;
        alu_result_in = 0;
        r_data2_in = 0;
        mux_RegDst_in = 0;
        wb_RegWrite_in = 0;
        wb_MemtoReg_in = 0;
        m_MemWrite_in = 0;
        opcode_in = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Basic Reset", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 1'b0, 5'h0, 6'h0, 32'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Normal Data Load", test_num);
        reset_dut();
        ena = 1;
        alu_result_in = 32'hDEADBEEF;
        r_data2_in = 32'hCAFEBABE;
        mux_RegDst_in = 5'h1A;
        wb_RegWrite_in = 1;
        wb_MemtoReg_in = 0;
        m_MemWrite_in = 1;
        opcode_in = 6'h23;
        @(posedge clk);
        #2 #1;
 check_outputs(32'hDEADBEEF, 1'b1, 5'h1A, 6'h23, 32'hCAFEBABE, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Enable Signal Low Protection", test_num);
        reset_dut();

        ena = 1;
        alu_result_in = 32'h11112222;
        r_data2_in = 32'h33334444;
        mux_RegDst_in = 5'h05;
        wb_RegWrite_in = 1;
        wb_MemtoReg_in = 1;
        m_MemWrite_in = 0;
        opcode_in = 6'h01;
        @(posedge clk);
        #1;

        ena = 0;
        alu_result_in = 32'hFFFFFFFF;
        r_data2_in = 32'hEEEEEEEE;
        @(posedge clk);

        #2 #1;
 check_outputs(32'h11112222, 1'b0, 5'h05, 6'h01, 32'h33334444, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Bit Pattern Check", test_num);
        reset_dut();
        ena = 1;
        alu_result_in = 32'h5555AAAA;
        r_data2_in = 32'hAAAA5555;
        mux_RegDst_in = 5'h1F;
        wb_RegWrite_in = 0;
        wb_MemtoReg_in = 1;
        m_MemWrite_in = 1;
        opcode_in = 6'h3F;
        @(posedge clk);
        #2 #1;
 check_outputs(32'h5555AAAA, 1'b1, 5'h1F, 6'h3F, 32'hAAAA5555, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Load then Reset", test_num);
        reset_dut();
        ena = 1;
        alu_result_in = 32'h12345678;
        @(posedge clk);
        #1 reset = 1;
        @(posedge clk);
        #2 #1;
 check_outputs(32'h0, 1'b0, 5'h0, 6'h0, 32'h0, 1'b0, 1'b0);
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
        input [31:0] expected_alu_result_out;
        input expected_m_MemWrite_out;
        input [4:0] expected_mux_RegDst_out;
        input [5:0] expected_opcode_out;
        input [31:0] expected_r_data2_out;
        input expected_wb_MemtoReg_out;
        input expected_wb_RegWrite_out;
        begin
            if (expected_alu_result_out === (expected_alu_result_out ^ alu_result_out ^ expected_alu_result_out) &&
                expected_m_MemWrite_out === (expected_m_MemWrite_out ^ m_MemWrite_out ^ expected_m_MemWrite_out) &&
                expected_mux_RegDst_out === (expected_mux_RegDst_out ^ mux_RegDst_out ^ expected_mux_RegDst_out) &&
                expected_opcode_out === (expected_opcode_out ^ opcode_out ^ expected_opcode_out) &&
                expected_r_data2_out === (expected_r_data2_out ^ r_data2_out ^ expected_r_data2_out) &&
                expected_wb_MemtoReg_out === (expected_wb_MemtoReg_out ^ wb_MemtoReg_out ^ expected_wb_MemtoReg_out) &&
                expected_wb_RegWrite_out === (expected_wb_RegWrite_out ^ wb_RegWrite_out ^ expected_wb_RegWrite_out)) begin
                $display("PASS");
                $display("  Outputs: alu_result_out=%h, m_MemWrite_out=%b, mux_RegDst_out=%h, opcode_out=%h, r_data2_out=%h, wb_MemtoReg_out=%b, wb_RegWrite_out=%b",
                         alu_result_out, m_MemWrite_out, mux_RegDst_out, opcode_out, r_data2_out, wb_MemtoReg_out, wb_RegWrite_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_result_out=%h, m_MemWrite_out=%b, mux_RegDst_out=%h, opcode_out=%h, r_data2_out=%h, wb_MemtoReg_out=%b, wb_RegWrite_out=%b",
                         expected_alu_result_out, expected_m_MemWrite_out, expected_mux_RegDst_out, expected_opcode_out, expected_r_data2_out, expected_wb_MemtoReg_out, expected_wb_RegWrite_out);
                $display("  Got:      alu_result_out=%h, m_MemWrite_out=%b, mux_RegDst_out=%h, opcode_out=%h, r_data2_out=%h, wb_MemtoReg_out=%b, wb_RegWrite_out=%b",
                         alu_result_out, m_MemWrite_out, mux_RegDst_out, opcode_out, r_data2_out, wb_MemtoReg_out, wb_RegWrite_out);
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
        $dumpvars(0,alu_result_in, clk, m_MemWrite_in, mux_RegDst_in, opcode_in, r_data2_in, reset, wb_MemtoReg_in, wb_RegWrite_in, alu_result_out, m_MemWrite_out, mux_RegDst_out, opcode_out, r_data2_out, wb_MemtoReg_out, wb_RegWrite_out);
    end

endmodule
