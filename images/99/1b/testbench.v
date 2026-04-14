`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg MemRead;
    reg MemWrite;
    reg MemtoReg;
    reg RegWrite;
    reg [31:0] alu;
    reg branch;
    reg clk;
    reg jump;
    reg [4:0] mux;
    reg [31:0] readdata2;
    reg rst;
    wire MemRead_out;
    wire MemWrite_out;
    wire MemtoReg_out;
    wire RegWrite_out;
    wire [31:0] alu_out;
    wire branch_out;
    wire jump_out;
    wire [4:0] mux_out;
    wire [31:0] readdata2_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .alu(alu),
        .branch(branch),
        .clk(clk),
        .jump(jump),
        .mux(mux),
        .readdata2(readdata2),
        .rst(rst),
        .MemRead_out(MemRead_out),
        .MemWrite_out(MemWrite_out),
        .MemtoReg_out(MemtoReg_out),
        .RegWrite_out(RegWrite_out),
        .alu_out(alu_out),
        .branch_out(branch_out),
        .jump_out(jump_out),
        .mux_out(mux_out),
        .readdata2_out(readdata2_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            branch = 0;
            jump = 0;
            MemRead = 0;
            MemWrite = 0;
            RegWrite = 0;
            MemtoReg = 0;
            alu = 0;
            readdata2 = 0;
            mux = 0;
            #15;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 32'h0, 0, 0, 5'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Clock Cycle Load (Data Pattern 1)", test_num);
            reset_dut();

            @(negedge clk);
            branch = 1;
            jump = 1;
            MemRead = 1;
            MemWrite = 0;
            RegWrite = 1;
            MemtoReg = 0;
            alu = 32'hDEADBEEF;
            readdata2 = 32'hCAFEBABE;
            mux = 5'd15;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0, 1, 32'hDEADBEEF, 1, 1, 5'd15, 32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Data Transfer", test_num);
            reset_dut();


            @(negedge clk);
            branch = 0; jump = 0; MemRead = 0; MemWrite = 1; RegWrite = 0; MemtoReg = 0;
            alu = 32'h11111111; readdata2 = 32'h22222222; mux = 5'h05;
            @(posedge clk);


            @(negedge clk);
            branch = 1; jump = 0; MemRead = 0; MemWrite = 0; RegWrite = 1; MemtoReg = 1;
            alu = 32'h88888888; readdata2 = 32'h99999999; mux = 5'h1A;

            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 1, 1, 32'h88888888, 1, 0, 5'h1A, 32'h99999999);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Signals High Pattern", test_num);
            reset_dut();

            @(negedge clk);
            branch = 1;
            jump = 1;
            MemRead = 1;
            MemWrite = 1;
            RegWrite = 1;
            MemtoReg = 1;
            alu = 32'hFFFFFFFF;
            readdata2 = 32'hFFFFFFFF;
            mux = 5'h1F;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1, 1, 1, 32'hFFFFFFFF, 1, 1, 5'h1F, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Store Word Instruction Pattern", test_num);
            reset_dut();

            @(negedge clk);
            branch = 0; jump = 0; MemRead = 0; MemWrite = 1;
            RegWrite = 0; MemtoReg = 0;
            alu = 32'h00000040;
            readdata2 = 32'hABCD1234;
            mux = 5'h00;

            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0, 0, 32'h00000040, 0, 0, 5'h00, 32'hABCD1234);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset Mid-Operation", test_num);
            reset_dut();


            @(negedge clk);
            alu = 32'h12345678; RegWrite = 1;
            @(posedge clk);
            #2;


            rst = 1;
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 32'h0, 0, 0, 5'h0, 32'h0);

            #5 rst = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Jump and Link Pattern", test_num);
            reset_dut();

            @(negedge clk);
            branch = 0; jump = 1; MemRead = 0; MemWrite = 0;
            RegWrite = 1; MemtoReg = 0;
            alu = 32'h00000800;
            readdata2 = 0;
            mux = 5'd31;

            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 1, 32'h00000800, 0, 1, 5'd31, 32'h0);
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
        input expected_MemRead_out;
        input expected_MemWrite_out;
        input expected_MemtoReg_out;
        input expected_RegWrite_out;
        input [31:0] expected_alu_out;
        input expected_branch_out;
        input expected_jump_out;
        input [4:0] expected_mux_out;
        input [31:0] expected_readdata2_out;
        begin
            if (expected_MemRead_out === (expected_MemRead_out ^ MemRead_out ^ expected_MemRead_out) &&
                expected_MemWrite_out === (expected_MemWrite_out ^ MemWrite_out ^ expected_MemWrite_out) &&
                expected_MemtoReg_out === (expected_MemtoReg_out ^ MemtoReg_out ^ expected_MemtoReg_out) &&
                expected_RegWrite_out === (expected_RegWrite_out ^ RegWrite_out ^ expected_RegWrite_out) &&
                expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out) &&
                expected_branch_out === (expected_branch_out ^ branch_out ^ expected_branch_out) &&
                expected_jump_out === (expected_jump_out ^ jump_out ^ expected_jump_out) &&
                expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out) &&
                expected_readdata2_out === (expected_readdata2_out ^ readdata2_out ^ expected_readdata2_out)) begin
                $display("PASS");
                $display("  Outputs: MemRead_out=%b, MemWrite_out=%b, MemtoReg_out=%b, RegWrite_out=%b, alu_out=%h, branch_out=%b, jump_out=%b, mux_out=%h, readdata2_out=%h",
                         MemRead_out, MemWrite_out, MemtoReg_out, RegWrite_out, alu_out, branch_out, jump_out, mux_out, readdata2_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MemRead_out=%b, MemWrite_out=%b, MemtoReg_out=%b, RegWrite_out=%b, alu_out=%h, branch_out=%b, jump_out=%b, mux_out=%h, readdata2_out=%h",
                         expected_MemRead_out, expected_MemWrite_out, expected_MemtoReg_out, expected_RegWrite_out, expected_alu_out, expected_branch_out, expected_jump_out, expected_mux_out, expected_readdata2_out);
                $display("  Got:      MemRead_out=%b, MemWrite_out=%b, MemtoReg_out=%b, RegWrite_out=%b, alu_out=%h, branch_out=%b, jump_out=%b, mux_out=%h, readdata2_out=%h",
                         MemRead_out, MemWrite_out, MemtoReg_out, RegWrite_out, alu_out, branch_out, jump_out, mux_out, readdata2_out);
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
        $dumpvars(0,MemRead, MemWrite, MemtoReg, RegWrite, alu, branch, clk, jump, mux, readdata2, rst, MemRead_out, MemWrite_out, MemtoReg_out, RegWrite_out, alu_out, branch_out, jump_out, mux_out, readdata2_out);
    end

endmodule
