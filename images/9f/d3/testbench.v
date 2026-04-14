`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] dir_wb_in;
    reg reg_wr_in;
    reg [31:0] result_alu_in;
    reg [31:0] result_mem_in;
    reg sel_wb_in;
    wire [3:0] dir_wb_out;
    wire reg_wr_out;
    wire [31:0] result_alu_out;
    wire [31:0] result_mem_out;
    wire sel_wb_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir_wb_in(dir_wb_in),
        .reg_wr_in(reg_wr_in),
        .result_alu_in(result_alu_in),
        .result_mem_in(result_mem_in),
        .sel_wb_in(sel_wb_in),
        .dir_wb_out(dir_wb_out),
        .reg_wr_out(reg_wr_out),
        .result_alu_out(result_alu_out),
        .result_mem_out(result_mem_out),
        .sel_wb_out(sel_wb_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            dir_wb_in = 4'b0;
            reg_wr_in = 1'b0;
            result_alu_in = 32'b0;
            result_mem_in = 32'b0;
            sel_wb_in = 1'b0;

            @(negedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Data Transfer", test_num);
            reset_dut();


            dir_wb_in = 4'h5;
            reg_wr_in = 1'b1;
            result_alu_in = 32'hAAAA_BBBB;
            result_mem_in = 32'hCCCC_DDDD;
            sel_wb_in = 1'b1;


            @(posedge clk);
            @(negedge clk);
            #1;

            #1;


            check_outputs(4'h5, 1'b1, 32'hAAAA_BBBB, 32'hCCCC_DDDD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-Ones Bit Pattern", test_num);
            reset_dut();

            dir_wb_in = 4'hF;
            reg_wr_in = 1'b1;
            result_alu_in = 32'hFFFF_FFFF;
            result_mem_in = 32'hFFFF_FFFF;
            sel_wb_in = 1'b1;

            @(posedge clk);
            @(negedge clk);
            #1;

            #1;


            check_outputs(4'hF, 1'b1, 32'hFFFF_FFFF, 32'hFFFF_FFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Disable Control", test_num);
            reset_dut();

            dir_wb_in = 4'hE;
            reg_wr_in = 1'b0;
            result_alu_in = 32'h1234_5678;
            result_mem_in = 32'h8765_4321;
            sel_wb_in = 1'b0;

            @(posedge clk);
            @(negedge clk);
            #1;


            #1;



            check_outputs(4'hE, 1'b0, 32'h1234_5678, 32'h8765_4321, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dual-Edge Timing Verification", test_num);
            reset_dut();


            dir_wb_in = 4'h1;
            @(posedge clk);
            @(negedge clk);


            dir_wb_in = 4'hA;
            result_alu_in = 32'hDEAD_BEEF;
            @(posedge clk);

            #1;


            if (dir_wb_out == 4'h1) begin
                $display("Mid-cycle check: Output correctly held old value after posedge.");
            end else begin
                $display("Mid-cycle check: FAIL - Output changed before negedge.");
            end

            @(negedge clk);
            #1;
            #1;

            check_outputs(4'hA, 1'b0, 32'hDEAD_BEEF, 32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-Zeros Bit Pattern", test_num);
            reset_dut();

            dir_wb_in = 4'h0;
            reg_wr_in = 1'b0;
            result_alu_in = 32'h0;
            result_mem_in = 32'h0;
            sel_wb_in = 1'b0;

            @(posedge clk);
            @(negedge clk);
            #1;

            #1;


            check_outputs(4'h0, 1'b0, 32'h0, 32'h0, 1'b0);
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
        input [3:0] expected_dir_wb_out;
        input expected_reg_wr_out;
        input [31:0] expected_result_alu_out;
        input [31:0] expected_result_mem_out;
        input expected_sel_wb_out;
        begin
            if (expected_dir_wb_out === (expected_dir_wb_out ^ dir_wb_out ^ expected_dir_wb_out) &&
                expected_reg_wr_out === (expected_reg_wr_out ^ reg_wr_out ^ expected_reg_wr_out) &&
                expected_result_alu_out === (expected_result_alu_out ^ result_alu_out ^ expected_result_alu_out) &&
                expected_result_mem_out === (expected_result_mem_out ^ result_mem_out ^ expected_result_mem_out) &&
                expected_sel_wb_out === (expected_sel_wb_out ^ sel_wb_out ^ expected_sel_wb_out)) begin
                $display("PASS");
                $display("  Outputs: dir_wb_out=%h, reg_wr_out=%b, result_alu_out=%h, result_mem_out=%h, sel_wb_out=%b",
                         dir_wb_out, reg_wr_out, result_alu_out, result_mem_out, sel_wb_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dir_wb_out=%h, reg_wr_out=%b, result_alu_out=%h, result_mem_out=%h, sel_wb_out=%b",
                         expected_dir_wb_out, expected_reg_wr_out, expected_result_alu_out, expected_result_mem_out, expected_sel_wb_out);
                $display("  Got:      dir_wb_out=%h, reg_wr_out=%b, result_alu_out=%h, result_mem_out=%h, sel_wb_out=%b",
                         dir_wb_out, reg_wr_out, result_alu_out, result_mem_out, sel_wb_out);
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
        $dumpvars(0,clk, dir_wb_in, reg_wr_in, result_alu_in, result_mem_in, sel_wb_in, dir_wb_out, reg_wr_out, result_alu_out, result_mem_out, sel_wb_out);
    end

endmodule
