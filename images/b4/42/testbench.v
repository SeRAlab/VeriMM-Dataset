`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg PCSrc;
    reg [31:0] alu_out;
    reg branch;
    reg clk;
    reg [31:0] ex_imm;
    reg [5:0] op;
    reg rst_n;
    reg [25:0] target_address;
    wire [7:0] pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCSrc(PCSrc),
        .alu_out(alu_out),
        .branch(branch),
        .clk(clk),
        .ex_imm(ex_imm),
        .op(op),
        .rst_n(rst_n),
        .target_address(target_address),
        .pc(pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        PCSrc = 0;
        alu_out = 0;
        branch = 0;
        ex_imm = 0;
        op = 0;
        target_address = 0;
        @(posedge clk);
        #1 rst_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Reset check");
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Sequential increment");
        reset_dut();

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Jump with PCSrc");
        reset_dut();
        PCSrc = 1;
        target_address = 26'h00000FF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: BEQ Taken (op=0x04, alu_out=0)");
        reset_dut();
        op = 6'h04;
        branch = 1;
        alu_out = 32'h0;
        ex_imm = 32'h05;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h06);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: BEQ Not Taken (op=0x04, alu_out!=0)");
        reset_dut();
        op = 6'h04;
        branch = 1;
        alu_out = 32'h1;
        ex_imm = 32'h05;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: BNE Taken (op=0x05, alu_out!=0)");
        reset_dut();
        op = 6'h05;
        branch = 1;
        alu_out = 32'hA;
        ex_imm = 32'h0A;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h0B);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: BNE Not Taken (op=0x05, alu_out=0)");
        reset_dut();
        op = 6'h05;
        branch = 1;
        alu_out = 32'h0;
        ex_imm = 32'h0A;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Multiple sequential steps");
        reset_dut();
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h03);
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
        testcase008();
        
        
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
        input [7:0] expected_pc;
        begin
            if (expected_pc === (expected_pc ^ pc ^ expected_pc)) begin
                $display("PASS");
                $display("  Outputs: pc=%h",
                         pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc=%h",
                         expected_pc);
                $display("  Got:      pc=%h",
                         pc);
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
        $dumpvars(0,PCSrc, alu_out, branch, clk, ex_imm, op, rst_n, target_address, pc);
    end

endmodule
