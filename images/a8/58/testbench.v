`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] dest_wb;
    reg [31:0] result_wb;
    reg rst;
    reg [3:0] src1;
    reg [3:0] src2;
    reg write_back_enable;
    wire [31:0] R0;
    wire [31:0] R1;
    wire [31:0] R10;
    wire [31:0] R11;
    wire [31:0] R2;
    wire [31:0] R3;
    wire [31:0] R4;
    wire [31:0] R5;
    wire [31:0] R6;
    wire [31:0] R7;
    wire [31:0] R8;
    wire [31:0] R9;
    wire [31:0] reg1;
    wire [31:0] reg2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dest_wb(dest_wb),
        .result_wb(result_wb),
        .rst(rst),
        .src1(src1),
        .src2(src2),
        .write_back_enable(write_back_enable),
        .R0(R0),
        .R1(R1),
        .R10(R10),
        .R11(R11),
        .R2(R2),
        .R3(R3),
        .R4(R4),
        .R5(R5),
        .R6(R6),
        .R7(R7),
        .R8(R8),
        .R9(R9),
        .reg1(reg1),
        .reg2(reg2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        dest_wb = 0;
        result_wb = 0;
        write_back_enable = 0;
        src1 = 0;
        src2 = 0;
        #10;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset and Initial Index Check");
        reset_dut();
        src1 = 4'd5;
        src2 = 4'd11;
        #5;

        #1;


        check_outputs(32'd0, 32'd1, 32'd10, 32'd11, 32'd2, 32'd3, 32'd4, 32'd5, 32'd6, 32'd7, 32'd8, 32'd9, 32'd5, 32'd11);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Basic Write to R4");
        reset_dut();
        @(posedge clk);
        dest_wb = 4'd4;
        result_wb = 32'hA5A5A5A5;
        write_back_enable = 1;
        src1 = 4'd4;
        src2 = 4'd0;
        @(negedge clk);
        #2;
        #1;

        check_outputs(32'd0, 32'd1, 32'd10, 32'd11, 32'd2, 32'd3, 32'hA5A5A5A5, 32'd5, 32'd6, 32'd7, 32'd8, 32'd9, 32'hA5A5A5A5, 32'd0);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Write with Enable=0 (Should not change)");
        reset_dut();
        @(posedge clk);
        dest_wb = 4'd8;
        result_wb = 32'hFFFFFFFF;
        write_back_enable = 0;
        src1 = 4'd8;
        src2 = 4'd1;
        @(negedge clk);
        #2;
        #1;

        check_outputs(32'd0, 32'd1, 32'd10, 32'd11, 32'd2, 32'd3, 32'd4, 32'd5, 32'd6, 32'd7, 32'd8, 32'd9, 32'd8, 32'd1);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Sequential Writes to R10 and R11");
        reset_dut();


        @(posedge clk);
        dest_wb = 4'd10; result_wb = 32'h10101010; write_back_enable = 1;
        @(negedge clk);


        @(posedge clk);
        dest_wb = 4'd11; result_wb = 32'h11111111;
        @(negedge clk);

        #2;
        src1 = 4'd10; src2 = 4'd11;
        #1;

        check_outputs(32'd0, 32'd1, 32'h10101010, 32'h11111111, 32'd2, 32'd3, 32'd4, 32'd5, 32'd6, 32'd7, 32'd8, 32'd9, 32'h10101010, 32'h11111111);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Writing to R0 and verifying reg1/reg2 selection");
        reset_dut();
        @(posedge clk);
        dest_wb = 4'd0;
        result_wb = 32'hDEADBEEF;
        write_back_enable = 1;
        @(negedge clk);
        #2;
        src1 = 4'd0;
        src2 = 4'd2;
        #1;

        check_outputs(32'hDEADBEEF, 32'd1, 32'd10, 32'd11, 32'd2, 32'd3, 32'd4, 32'd5, 32'd6, 32'd7, 32'd8, 32'd9, 32'hDEADBEEF, 32'd2);
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
        input [31:0] expected_R0;
        input [31:0] expected_R1;
        input [31:0] expected_R10;
        input [31:0] expected_R11;
        input [31:0] expected_R2;
        input [31:0] expected_R3;
        input [31:0] expected_R4;
        input [31:0] expected_R5;
        input [31:0] expected_R6;
        input [31:0] expected_R7;
        input [31:0] expected_R8;
        input [31:0] expected_R9;
        input [31:0] expected_reg1;
        input [31:0] expected_reg2;
        begin
            if (expected_R0 === (expected_R0 ^ R0 ^ expected_R0) &&
                expected_R1 === (expected_R1 ^ R1 ^ expected_R1) &&
                expected_R10 === (expected_R10 ^ R10 ^ expected_R10) &&
                expected_R11 === (expected_R11 ^ R11 ^ expected_R11) &&
                expected_R2 === (expected_R2 ^ R2 ^ expected_R2) &&
                expected_R3 === (expected_R3 ^ R3 ^ expected_R3) &&
                expected_R4 === (expected_R4 ^ R4 ^ expected_R4) &&
                expected_R5 === (expected_R5 ^ R5 ^ expected_R5) &&
                expected_R6 === (expected_R6 ^ R6 ^ expected_R6) &&
                expected_R7 === (expected_R7 ^ R7 ^ expected_R7) &&
                expected_R8 === (expected_R8 ^ R8 ^ expected_R8) &&
                expected_R9 === (expected_R9 ^ R9 ^ expected_R9) &&
                expected_reg1 === (expected_reg1 ^ reg1 ^ expected_reg1) &&
                expected_reg2 === (expected_reg2 ^ reg2 ^ expected_reg2)) begin
                $display("PASS");
                $display("  Outputs: R0=%h, R1=%h, R10=%h, R11=%h, R2=%h, R3=%h, R4=%h, R5=%h, R6=%h, R7=%h, R8=%h, R9=%h, reg1=%h, reg2=%h",
                         R0, R1, R10, R11, R2, R3, R4, R5, R6, R7, R8, R9, reg1, reg2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R0=%h, R1=%h, R10=%h, R11=%h, R2=%h, R3=%h, R4=%h, R5=%h, R6=%h, R7=%h, R8=%h, R9=%h, reg1=%h, reg2=%h",
                         expected_R0, expected_R1, expected_R10, expected_R11, expected_R2, expected_R3, expected_R4, expected_R5, expected_R6, expected_R7, expected_R8, expected_R9, expected_reg1, expected_reg2);
                $display("  Got:      R0=%h, R1=%h, R10=%h, R11=%h, R2=%h, R3=%h, R4=%h, R5=%h, R6=%h, R7=%h, R8=%h, R9=%h, reg1=%h, reg2=%h",
                         R0, R1, R10, R11, R2, R3, R4, R5, R6, R7, R8, R9, reg1, reg2);
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
        $dumpvars(0,clk, dest_wb, result_wb, rst, src1, src2, write_back_enable, R0, R1, R10, R11, R2, R3, R4, R5, R6, R7, R8, R9, reg1, reg2);
    end

endmodule
