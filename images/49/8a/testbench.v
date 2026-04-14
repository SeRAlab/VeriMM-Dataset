`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] i_a;
    reg [3:0] i_aluc;
    reg i_aluimm;
    reg [31:0] i_b;
    reg [31:0] i_imm;
    reg i_jal;
    reg i_m2reg;
    reg [7:0] i_pc4;
    reg [4:0] i_rn;
    reg [4:0] i_sa;
    reg i_shift;
    reg i_wmem;
    reg i_wreg;
    reg rst;
    wire [31:0] o_a;
    wire [3:0] o_aluc;
    wire o_aluimm;
    wire [31:0] o_b;
    wire [31:0] o_imm;
    wire o_jal;
    wire o_m2reg;
    wire [7:0] o_pc4;
    wire [4:0] o_rn;
    wire [4:0] o_sa;
    wire o_shift;
    wire o_wmem;
    wire o_wreg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_a(i_a),
        .i_aluc(i_aluc),
        .i_aluimm(i_aluimm),
        .i_b(i_b),
        .i_imm(i_imm),
        .i_jal(i_jal),
        .i_m2reg(i_m2reg),
        .i_pc4(i_pc4),
        .i_rn(i_rn),
        .i_sa(i_sa),
        .i_shift(i_shift),
        .i_wmem(i_wmem),
        .i_wreg(i_wreg),
        .rst(rst),
        .o_a(o_a),
        .o_aluc(o_aluc),
        .o_aluimm(o_aluimm),
        .o_b(o_b),
        .o_imm(o_imm),
        .o_jal(o_jal),
        .o_m2reg(o_m2reg),
        .o_pc4(o_pc4),
        .o_rn(o_rn),
        .o_sa(o_sa),
        .o_shift(o_shift),
        .o_wmem(o_wmem),
        .o_wreg(o_wreg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        i_a = 0;
        i_aluc = 0;
        i_aluimm = 0;
        i_b = 0;
        i_imm = 0;
        i_jal = 0;
        i_m2reg = 0;
        i_pc4 = 0;
        i_rn = 0;
        i_sa = 0;
        i_shift = 0;
        i_wmem = 0;
        i_wreg = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset verification", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 4'h0, 1'b0, 32'h0, 32'h0, 1'b0, 1'b0, 8'h0, 5'h0, 5'h0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Basic Data Transfer", test_num);
        reset_dut();

        i_a = 32'hAAAA_BBBB;
        i_aluc = 4'h5;
        i_aluimm = 1'b1;
        i_b = 32'hCCCC_DDDD;
        i_imm = 32'h1234_5678;
        i_jal = 1'b0;
        i_m2reg = 1'b1;
        i_pc4 = 8'h40;
        i_rn = 5'd15;
        i_sa = 5'd4;
        i_shift = 1'b1;
        i_wmem = 1'b0;
        i_wreg = 1'b1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hAAAA_BBBB, 4'h5, 1'b1, 32'hCCCC_DDDD, 32'h1234_5678, 1'b0, 1'b1, 8'h40, 5'd15, 5'd4, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Pattern Data Transfer", test_num);
        reset_dut();

        i_a = 32'h5555_5555;
        i_aluc = 4'hF;
        i_aluimm = 1'b0;
        i_b = 32'h0000_FFFF;
        i_imm = 32'hFFFF_0000;
        i_jal = 1'b1;
        i_m2reg = 1'b0;
        i_pc4 = 8'hFF;
        i_rn = 5'd31;
        i_sa = 5'd31;
        i_shift = 1'b0;
        i_wmem = 1'b1;
        i_wreg = 1'b0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h5555_5555, 4'hF, 1'b0, 32'h0000_FFFF, 32'hFFFF_0000, 1'b1, 1'b0, 8'hFF, 5'd31, 5'd31, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Reset Priority over Inputs", test_num);
        reset_dut();


        i_a = 32'hFFFF_FFFF;
        i_wreg = 1'b1;
        i_aluc = 4'hA;


        rst = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h0, 4'h0, 1'b0, 32'h0, 32'h0, 1'b0, 1'b0, 8'h0, 5'h0, 5'h0, 1'b0, 1'b0, 1'b0);
        rst = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Sequential Timing Check", test_num);
        reset_dut();


        i_a = 32'h1;
        i_pc4 = 8'h04;
        @(posedge clk);
        #2;


        i_a = 32'h2;
        i_pc4 = 8'h08;
        #1;

        if (o_a == 32'h1 && o_pc4 == 8'h04) begin
            $display("Internal Check: Output held mid-cycle (PASS)");
        end else begin
            $display("Internal Check: Output changed mid-cycle (FAIL)");
        end

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h2, 4'h0, 1'b0, 32'h0, 32'h0, 1'b0, 1'b0, 8'h08, 5'h0, 5'h0, 1'b0, 1'b0, 1'b0);
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
        input [31:0] expected_o_a;
        input [3:0] expected_o_aluc;
        input expected_o_aluimm;
        input [31:0] expected_o_b;
        input [31:0] expected_o_imm;
        input expected_o_jal;
        input expected_o_m2reg;
        input [7:0] expected_o_pc4;
        input [4:0] expected_o_rn;
        input [4:0] expected_o_sa;
        input expected_o_shift;
        input expected_o_wmem;
        input expected_o_wreg;
        begin
            if (expected_o_a === (expected_o_a ^ o_a ^ expected_o_a) &&
                expected_o_aluc === (expected_o_aluc ^ o_aluc ^ expected_o_aluc) &&
                expected_o_aluimm === (expected_o_aluimm ^ o_aluimm ^ expected_o_aluimm) &&
                expected_o_b === (expected_o_b ^ o_b ^ expected_o_b) &&
                expected_o_imm === (expected_o_imm ^ o_imm ^ expected_o_imm) &&
                expected_o_jal === (expected_o_jal ^ o_jal ^ expected_o_jal) &&
                expected_o_m2reg === (expected_o_m2reg ^ o_m2reg ^ expected_o_m2reg) &&
                expected_o_pc4 === (expected_o_pc4 ^ o_pc4 ^ expected_o_pc4) &&
                expected_o_rn === (expected_o_rn ^ o_rn ^ expected_o_rn) &&
                expected_o_sa === (expected_o_sa ^ o_sa ^ expected_o_sa) &&
                expected_o_shift === (expected_o_shift ^ o_shift ^ expected_o_shift) &&
                expected_o_wmem === (expected_o_wmem ^ o_wmem ^ expected_o_wmem) &&
                expected_o_wreg === (expected_o_wreg ^ o_wreg ^ expected_o_wreg)) begin
                $display("PASS");
                $display("  Outputs: o_a=%h, o_aluc=%h, o_aluimm=%b, o_b=%h, o_imm=%h, o_jal=%b, o_m2reg=%b, o_pc4=%h, o_rn=%h, o_sa=%h, o_shift=%b, o_wmem=%b, o_wreg=%b",
                         o_a, o_aluc, o_aluimm, o_b, o_imm, o_jal, o_m2reg, o_pc4, o_rn, o_sa, o_shift, o_wmem, o_wreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_a=%h, o_aluc=%h, o_aluimm=%b, o_b=%h, o_imm=%h, o_jal=%b, o_m2reg=%b, o_pc4=%h, o_rn=%h, o_sa=%h, o_shift=%b, o_wmem=%b, o_wreg=%b",
                         expected_o_a, expected_o_aluc, expected_o_aluimm, expected_o_b, expected_o_imm, expected_o_jal, expected_o_m2reg, expected_o_pc4, expected_o_rn, expected_o_sa, expected_o_shift, expected_o_wmem, expected_o_wreg);
                $display("  Got:      o_a=%h, o_aluc=%h, o_aluimm=%b, o_b=%h, o_imm=%h, o_jal=%b, o_m2reg=%b, o_pc4=%h, o_rn=%h, o_sa=%h, o_shift=%b, o_wmem=%b, o_wreg=%b",
                         o_a, o_aluc, o_aluimm, o_b, o_imm, o_jal, o_m2reg, o_pc4, o_rn, o_sa, o_shift, o_wmem, o_wreg);
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
        $dumpvars(0,clk, i_a, i_aluc, i_aluimm, i_b, i_imm, i_jal, i_m2reg, i_pc4, i_rn, i_sa, i_shift, i_wmem, i_wreg, rst, o_a, o_aluc, o_aluimm, o_b, o_imm, o_jal, o_m2reg, o_pc4, o_rn, o_sa, o_shift, o_wmem, o_wreg);
    end

endmodule
