`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg do_exception;
    reg [31:0] mem_alu_result;
    reg [31:0] mem_lsu_result;
    reg mem_op_load;
    reg [31:0] mem_pc;
    reg [4:0] mem_rf_r_addr;
    reg mem_rf_r_we;
    reg mem_stall;
    reg rst;
    reg [31:0] wb_mul_result;
    reg wb_op_mul;
    wire [31:0] wb_rf_r;
    wire [4:0] wb_rf_r_addr;
    wire wb_rf_r_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .do_exception(do_exception),
        .mem_alu_result(mem_alu_result),
        .mem_lsu_result(mem_lsu_result),
        .mem_op_load(mem_op_load),
        .mem_pc(mem_pc),
        .mem_rf_r_addr(mem_rf_r_addr),
        .mem_rf_r_we(mem_rf_r_we),
        .mem_stall(mem_stall),
        .rst(rst),
        .wb_mul_result(wb_mul_result),
        .wb_op_mul(wb_op_mul),
        .wb_rf_r(wb_rf_r),
        .wb_rf_r_addr(wb_rf_r_addr),
        .wb_rf_r_we(wb_rf_r_we)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            do_exception = 0;
            mem_stall = 0;
            mem_pc = 0;
            mem_alu_result = 0;
            mem_lsu_result = 0;
            mem_rf_r_we = 0;
            mem_rf_r_addr = 0;
            mem_op_load = 0;
            wb_op_mul = 0;
            wb_mul_result = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            mem_alu_result = 32'hDEADBEEF;
            mem_rf_r_addr = 5'd15;
            mem_rf_r_we = 1;
            mem_op_load = 0;
            wb_op_mul = 0;
            do_exception = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 5'd15, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            mem_lsu_result = 32'hCAFEBABE;
            mem_op_load = 1;
            mem_rf_r_addr = 5'd8;
            mem_rf_r_we = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCAFEBABE, 5'd8, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            wb_mul_result = 32'h12345678;
            wb_op_mul = 1;
            mem_op_load = 0;
            mem_rf_r_addr = 5'd4;
            mem_rf_r_we = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 5'd4, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            mem_pc = 32'h00001004;
            do_exception = 1;
            mem_alu_result = 32'hFFFFFFFF;
            mem_rf_r_addr = 5'd31;
            mem_rf_r_we = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00001004, 5'd31, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            mem_rf_r_we = 0;
            mem_rf_r_addr = 5'd10;
            mem_alu_result = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 5'd10, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            wb_op_mul = 1;
            mem_op_load = 1;
            wb_mul_result = 32'hAAAA_AAAA;
            mem_lsu_result = 32'hBBBB_BBBB;
            mem_rf_r_addr = 5'd5;
            mem_rf_r_we = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_AAAA, 5'd5, 1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;

            mem_alu_result = 32'h1111_1111;
            mem_rf_r_addr = 5'd1;
            mem_rf_r_we = 1;
            mem_stall = 0;
            @(posedge clk);
            #1;

            mem_stall = 1;
            mem_alu_result = 32'h2222_2222;
            mem_rf_r_addr = 5'd2;
            mem_rf_r_we = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h1111_1111, 5'd1, 1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            do_exception = 1;
            wb_op_mul = 1;
            mem_op_load = 1;
            mem_pc = 32'h8000_0000;
            wb_mul_result = 32'h0;
            mem_lsu_result = 32'h0;
            mem_alu_result = 32'h0;
            mem_rf_r_addr = 5'd20;
            mem_rf_r_we = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h8000_0000, 5'd20, 1);
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
        input [31:0] expected_wb_rf_r;
        input [4:0] expected_wb_rf_r_addr;
        input expected_wb_rf_r_we;
        begin
            if (expected_wb_rf_r === (expected_wb_rf_r ^ wb_rf_r ^ expected_wb_rf_r) &&
                expected_wb_rf_r_addr === (expected_wb_rf_r_addr ^ wb_rf_r_addr ^ expected_wb_rf_r_addr) &&
                expected_wb_rf_r_we === (expected_wb_rf_r_we ^ wb_rf_r_we ^ expected_wb_rf_r_we)) begin
                $display("PASS");
                $display("  Outputs: wb_rf_r=%h, wb_rf_r_addr=%h, wb_rf_r_we=%b",
                         wb_rf_r, wb_rf_r_addr, wb_rf_r_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_rf_r=%h, wb_rf_r_addr=%h, wb_rf_r_we=%b",
                         expected_wb_rf_r, expected_wb_rf_r_addr, expected_wb_rf_r_we);
                $display("  Got:      wb_rf_r=%h, wb_rf_r_addr=%h, wb_rf_r_we=%b",
                         wb_rf_r, wb_rf_r_addr, wb_rf_r_we);
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
        $dumpvars(0,clk, do_exception, mem_alu_result, mem_lsu_result, mem_op_load, mem_pc, mem_rf_r_addr, mem_rf_r_we, mem_stall, rst, wb_mul_result, wb_op_mul, wb_rf_r, wb_rf_r_addr, wb_rf_r_we);
    end

endmodule
